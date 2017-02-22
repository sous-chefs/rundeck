if defined?(ChefSpec)
  ChefSpec.define_matcher(:simple_passenger_app)
  def create_rundeck_project(name)
    ChefSpec::Matchers::ResourceMatcher.new(:rundeck_project, :create, name)
  end
end
