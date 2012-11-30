#
# Cookbook Name:: wt_base
# Library:: helper
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

require 'chef/mixin/shell_out'
require 'open-uri'

module WtBase
  module Helper
    include Chef::Mixin::ShellOut

    def get_build(target, source=nil)

      # determine location of target file from various points of configuration
      source = ENV['download_url'] if ENV['download_url']
      source = ENV['build_url'] if ENV['build_url'] if source.nil?
      source = get_source_from_attributes if source.nil?
      raise Chef::Exceptions::FileNotFound, "no source provided" if source.nil?

      # remove quotes
      source = source.gsub(/"/,'')
      log "get_build: target => #{target} source => #{source}"

      # determine true location of the target file
      if (source =~ /^https?:\/.*\/([^\/]*)$/)
        if ($1 =~ /^#{URI::encode(target)}$/i)
          source = URI::encode(source)
        else
          source = URI::encode(source + "/" + target)
          source =~ /^(https?:\/\/)(.*)$?/
          source = $1 + $2.gsub(/\/+/, "/")
        end
      elsif (source =~ /^.*[\/\\]([^\/\\]*)$/)
        src_basename= $1
        if (src_basename =~ /\.zip$/i) and (src_basename !~ /^#{Regexp.escape(target)}$/i)
          log "get_build: got non_target_zip"
          non_target_zip = true
        elsif (src_basename !~ /^#{Regexp.escape(target)}$/i)
          log "get_build: searching for #{target} in #{source}"
          source = find(source, target).first
          raise Chef::Exceptions::FileNotFound, target if source.nil?
        end
      else
        raise Chef::Exceptions::FileNotFound, "relative paths are not support, source => #{source}"
      end
      log "get_build: using source location #{source}"

      # confirm existence
      unless (source =~ /^https?:\/\//)
        unless File::exist?(source)
          raise Chef::Exceptions::FileNotFound, "not found: #{source}"
        end
      end

      # store attribute
      cb_config['installed_from'] = source

      # drop location
      if non_target_zip
        cache_dest = "#{Chef::Config[:file_cache_path]}/#{::File.basename(source)}"
      else
        cache_dest = "#{Chef::Config[:file_cache_path]}/#{::File.basename(target)}"
      end

      # http and non zip
      if (source =~ /^https?:\/\//) and (source !~ /\.zip$/i)
        log("copy #{source} to #{cache_dest}") { level :debug }
        r = Chef::Resource::RemoteFile.new(cache_dest, run_context)
        r.source(source)
        r.run_action(:create)
        use_target = cache_dest

      # http and zip
      elsif (source =~ /^https?:\/\//)
        use_target = source

      # unc
      elsif (source =~ /^\\\\/)
        # TO DO:  mount share with alternate credentials
        log("copy unc #{source} to #{cache_dest}") { level :debug }
        if non_target_zip
          shell_out('copy /y "' + source + '" "' + Chef::Config[:file_cache_path] +'"')
          use_target = "#{Chef::Config[:file_cache_path]}/#{src_basename}"
        else
          shell_out('copy /y "' + source + '" "' + cache_dest + '"')
          use_target = cache_dest
        end

      # local
      else
        log("copy #{source} to #{cache_dest}") { level :debug }
        case node['platform']
          when "windows", "mswin", "mingw32"
            shell_out('copy /y "' + source + '" "' + cache_dest + '"')
          else
            log "FileUtil: source => #{source} cache_dest => #{cache_dest}"
            FileUtils::cp(source, cache_dest) unless source == cache_dest
        end
        use_target = cache_dest
      end

      # search zip for target (i.e. teamcity artifacts zip)
      if non_target_zip

        case node['platform']
          when "windows", "mswin", "mingw32"
            tmpdir = "#{Chef::Config[:file_cache_path]}/" + cookbook_name + "-tmp"
            z = Chef::Resource::WindowsZipfile.new(tmpdir, run_context)
            z.source(use_target)
            z.overwrite(true)
            z.run_action(:unzip)
          else
            tmpdir = "#{Chef::Config[:file_cache_path]}/" + cookbook_name + "-tmp"
            cmd = shell_out('unzip -o "' + use_target + '" -d "' + tmpdir + '"')
            if cmd.exitstatus > 0
              Chef::Application.fatal!("failed to unzip #{use_target} to #{tmpdir}")
            end
        end
        log "get_build: searching for (non_target_zip) #{target} in #{tmpdir}"
        use_target = find(tmpdir, target).first
        raise Chef::Exceptions::FileNotFound, target if use_target.nil?

      end

      log "get_build: use_target => " + use_target
      use_target

    end

    def get_source_from_attributes
      if cb_config['download_url']
        cb_config['download_url']
      elsif cb_config['build_url']
        cb_config['build_url']
      elsif wt_config['install_server'] and cb_config['suburl']
        src = wt_config['install_server'] + "/" + cb_config['suburl']
        src =~ /^(https?:\/\/)(.*)$?/
        src = $1 + $2.gsub(/\/+/, "/")
      elsif wt_config['install_server'] and cb_config['url']
        src = wt_config['install_server'] + "/" + cb_config['url']
        src =~ /^(https?:\/\/)(.*)$?/
        src = $1 + $2.gsub(/\/+/, "/")
      else
        cb_config['installed_from']
      end
    end

    # find the full path of a file
    def find(dir, filename="*.*", subdirs=true)
      case node['platform']
        when "windows", "mswin", "mingw32"
          #cmd = Chef::ShellOut.new('dir /o:n /s /b "' + dir + '\*' + filename + '"')
          cmd = shell_out('dir /o:n /s /b "' + dir + '\*' + filename + '"')
          cmd.run_command
          cmd.stdout.split(/\r\n/)
        else
          dir = dir.gsub(/\\/, '/').gsub(/([\[\]\{\}\*\?\\])/, '\\\\\1')
          log "find: dir => #{dir} filename => #{filename}"
          Dir[ subdirs ? ::File.join(dir, "**", filename) : ::File.join(dir, filename) ]
      end
    end

    def deploy_mode?
      case ENV['DEPLOY'] or ENV['deploy_build']
        when /false/i, 0, nil
          log "deploy mode disabled"
          false
        else
          log "deploy mode enabled"
          true
      end
    end

    # this currently does not work in unix
    # a child process cannot change a parent's environment
    def disable_deploy_mode
      return unless node['platform'] == "windows"
      log "disabling deploy mode"
      env "deploy_build" do
        value "false"
        action :modify
      end
      env "DEPLOY" do
        value "false"
        action :modify
      end
    end

    # grant share/file system access to "log" readers
    def share_wrs
      return unless node['platform'] == "windows"
      log "sharing wrs"
      wt_base_netshare "wrs" do
        action :grant
        path wt_config['install_dir_windows']
        user "Everyone"
        perm :full
        remark "shared by chef"
        returns [0, 2]
      end
      unless wt_config['wrsread_group'].nil?
        wt_base_icacls wt_config['install_dir_windows'] do
          action :grant
          user wt_config['wrsread_group']
          perm :read
        end
      end
      unless wt_config['wrsmodify_group'].nil?
        wt_base_icacls wt_config['install_dir_windows'] do
          action :grant
          user wt_config['wrsmodify_group']
          perm :modify
        end
      end
    end

    # unshare wrs folder
    def unshare_wrs
      return unless node['platform'] == "windows"
      log "unsharing wrs"
      wt_base_netshare "wrs" do
        action :remove
        returns [0, 2]
      end
      unless wt_config['wrsread_group'].nil?
        wt_base_icacls wt_config['install_dir_windows'] do
          action :remove
          user wt_config['wrsread_group']
        end
      end
      unless wt_config['wrsmodify_group'].nil?
        wt_base_icacls wt_config['install_dir_windows'] do
          action :remove
          user wt_config['wrsmodify_group']
        end
      end
    end

  end
end

Chef::Recipe.send(:include, WtBase::Helper)
