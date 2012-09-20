actions :create_if_missing

attribute :app_file,                :kind_of => String
attribute :app_version,             :kind_of => String
attribute :required_dependencies,   :kind_of => Array
attribute :local_templates,         :kind_of => Array
attribute :local_templates_directory, :kind_of => String
attribute :remove_dir_on_upgrade,   :kind_of => String