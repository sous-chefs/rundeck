attr_reader :manifest_file

def load_current_resource
 	chef_gem "activesupport" do
    version "3.2.11"
  end
  @manifest_file               = ::File.join(install_dir, "manifest.yaml")
 end

action :create do
	
	@deploy = should_we_deploy?

	if deploy?
		remove_old_plugin
		create_dirs
		retrieve_artifact
		extract
		run_proc :after_deploy
	end

	run_proc :configure
	recipe_eval { write_manifest }

	if deploy? || has_manifest_changed?
		run_proc :restart
	end
  new_resource.updated_by_last_action(true)
end

private

  # @return [Boolean] the deploy instance variable
  def deploy?
    @deploy
  end

  def tarball
  	@tarball ||= begin
  		new_resource.download_url.split("/")[-1]
  	end
  end

  def install_dir
  	new_resource.install_dir
  end

  #
  def remove_old_plugin
  	tar = tarball
    Chef::Log.info "wt_portfolio_harness_plugin[remove_old_plugin] Deleting existing #{new_resource.name} plugin"
  	recipe_eval do
	  	execute "delete_#{new_resource.name}_source" do
		    user "root"
		    group "root"
		    command "rm -f #{Chef::Config[:file_cache_path]}/#{tar}"
		    action :run
		  end
	  	directory new_resource.install_dir do
				action :delete
				recursive true
			end
		end
	end

	# Creates the conf and install dir. 
  # Run as two seperate resources in case the conf dir is not below install dir
  def create_dirs
  	recipe_eval do
	  		directory new_resource.conf_dir do
			    owner "root"
			    group "root"
			    mode 00755
			    recursive true
			    action :create
				end
        directory new_resource.install_dir do
          owner "root"
          group "root"
          mode 00755
          recursive true
          action :create
        end
		end
	end

	# Downloads the tarball into the cache directory
  def retrieve_artifact  
	 	tar = tarball
  	recipe_eval do
  		remote_file "#{Chef::Config[:file_cache_path]}/#{tar}" do
			  source new_resource.download_url
			  mode 00644
			  action :create
			end
		end
	end

  # Extract tarbal into install directory
	def extract
    tar = tarball
  	recipe_eval do
  		execute "Untar_#{new_resource.name}" do
			  user  "root"
			  group "root"
			  cwd new_resource.install_dir
			  command "tar zxf #{Chef::Config[:file_cache_path]}/#{tar}"
			  creates "#{new_resource.install_dir}/lib"
			end 
		end
	end

  # Determines if a deploy is needed

  def should_we_deploy?
  	if new_resource.force_deploy # Are we forcing a build?(ie. deploy_build = true)
      Chef::Log.info "wt_portfolio_harness_plugin[should_we_deploy?] Force attribute has been set for #{new_resource.name}."
      Chef::Log.info "wt_portfolio_harness_plugin[should_we_deploy?] Installing new plugin for #{new_resource.name}."
      return true
    elsif !(::File.directory? install_dir) # Is the plugin not installed at all?
      Chef::Log.info "wt_portfolio_harness_plugin[should_we_deploy?] No current version installed for #{new_resource.name}."
      Chef::Log.info "wt_portfolio_harness_plugin[should_we_deploy?] Installing new plugin for #{new_resource.name}."
      return true
    end
  end

  # A wrapper that adds debug logging for running a recipe_eval on the 
  # numerous Proc attributes defined for this resource.
  # 
  # @param name [Symbol] the name of the proc to execute
  # 
  # @return [void]
  #Pulled from artifact cookbook
  def run_proc(name)
    proc = new_resource.send(name)
    proc_name = name.to_s
    Chef::Log.info "wt_portfolio_harness_plugin[run_proc::#{proc_name}] Determining whether to execute #{proc_name} proc."
    if proc
      Chef::Log.debug "wt_portfolio_harness_plugin[run_proc::#{proc_name}] Beginning execution of #{proc_name} proc."
      recipe_eval(&proc)
      Chef::Log.debug "wt_portfolio_harness_plugin[run_proc::#{proc_name}] Ending execution of #{proc_name} proc."
    else
      Chef::Log.info "wt_portfolio_harness_plugin[run_proc::#{proc_name}] Skipping execution of #{proc_name} proc because it was not defined."
    end
  end

    # Generates a manifest for all the files underneath the given files_path. SHA1 digests will be
  # generated for all files under the given files_path with the exception of directories and the 
  # manifest.yaml file itself.
  # 
  # @param  files_path [String] a path to the files that a manfiest will be generated for
  # 
  # @return [Hash] a mapping of file_path => SHA1 of that file
  def generate_manifest(files_path)
    Chef::Log.info "wt_portfolio_harness_plugin[generate_manifest] Generating manifest for files in #{files_path}"
    files_in_release_path = Dir[::File.join(files_path, "**/*")].reject { |file| ::File.directory?(file) || file =~ /manifest.yaml/ }

    {}.tap do |map|
      files_in_release_path.each { |file| map[file] = Digest::SHA1.file(file).hexdigest }
    end
  end

  # Loads the saved manifest.yaml file and generates a new, current manifest. The
  # saved manifest is then parsed through looking for files that may have been deleted,
  # added, or modified.
  # 
  # @return [Boolean]
  def has_manifest_changed?
    require 'active_support/core_ext/hash'

    Chef::Log.info "wt_portfolio_harness_plugin[has_manifest_changed?] Loading manifest.yaml file from directory: #{install_dir}"
    begin
      saved_manifest = YAML.load_file(::File.join(install_dir, "manifest.yaml"))
    rescue Errno::ENOENT
      Chef::Log.warn "wt_portfolio_harness_plugin[has_manifest_changed?] Cannot load manifest.yaml. It may have been deleted. Deploying."
      return true
    end

    current_manifest = generate_manifest(install_dir)
    Chef::Log.info "wt_portfolio_harness_plugin[has_manifest_changed?] Comparing saved manifest from #{install_dir} with regenerated manifest from #{install_dir}."

    differences = !saved_manifest.diff(current_manifest).empty?
    if differences
      Chef::Log.info "wt_portfolio_harness_plugin[has_manifest_changed?] Saved manifest from #{install_dir} differs from regenerated manifest. Deploying."
      return true
    else
      Chef::Log.info "wt_portfolio_harness_plugin[has_manifest_changed?] Saved manifest from #{install_dir} is the same as regenerated manifest. Not Deploying."
      return false
    end
  end

  # Generates a manfiest Hash for the files under the release_path and
  # writes a YAML dump of the created Hash to manifest_file.
  # 
  # @return [String] a String of the YAML dumped to the manifest.yaml file
  def write_manifest
    manifest = generate_manifest(install_dir)
    Chef::Log.info "wt_portfolio_harness_plugin[write_manifest] Writing manifest.yaml file to #{manifest_file}"
    ::File.open(manifest_file, "w") { |file| file.puts YAML.dump(manifest) }
  end
