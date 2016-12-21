require 'bundler/setup'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run Test Kitchen integration tests'
namespace :integration do
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    instances = instances.get_all(Regexp.new(regexp)) unless regexp.nil? || regexp == 'all'
    raise Kitchen::UserError, "regexp '#{regexp}' matched 0 instances" if instances.empty?
    instances
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param concurrency [#to_i] number of instances to run the action against concurrently.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, concurrency, loader_config = {})
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }

    call_threaded(
      kitchen_instances(regexp, config),
      action,
      concurrency
    )
  end

  # Calls a method on a list of objects in concurrent threads.
  #
  # @param objects [Array] list of objects.
  # @param method_name [#to_s] method to call on the objects.
  # @param concurrency [Integer] number of objects to call the method on concurrently.
  # @return void
  def call_threaded(objects, method_name, concurrency)
    puts "method_name: #{method_name}, concurrency: #{concurrency}"
    threads = []
    raise 'concurrency must be > 0' if concurrency < 1
    objects.each do |obj|
      sleep 3 until threads.map(&:alive?).count(true) < concurrency
      threads << Thread.new { obj.method(method_name).call }
    end
    threads.map(&:join)
  end

  desc 'Run integration tests with kitchen-vagrant'
  task :vagrant, [:action, :regexp, :concurrency] do |_t, args|
    args.with_defaults(action: 'test', regexp: 'all', concurrency: 1)
    run_kitchen(args.action, args.regexp, args.concurrency.to_i)
  end

  desc 'Run integration tests with kitchen-docker'
  task :docker, [:action, :regexp, :concurrency] do |_t, args|
    args.with_defaults(action: 'test', regexp: 'all', concurrency: 1)
    run_kitchen(
      args.action,
      args.regexp,
      args.concurrency.to_i,
      local_config: '.kitchen.docker.yml'
    )
  end
end
