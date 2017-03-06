if defined?(ChefSpec)
  ChefSpec.define_matcher(:rundeck_project)
  def create_rundeck_project(name)
    ChefSpec::Matchers::ResourceMatcher.new(:rundeck_project, :create, name)
  end
end
