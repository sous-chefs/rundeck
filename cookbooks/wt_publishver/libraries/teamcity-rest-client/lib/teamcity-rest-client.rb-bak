require 'open-uri'
require 'rexml/document'
require 'set'

module TeamcityRestClient
  
  class Filter
  end
  
  class IncludeAllFilter
    def retain? thing
      true
    end
    def misses
      []
    end
  end
  
  class ExcludeNoneFilter
    def retain? thing
      true
    end
    def misses
      []
    end
  end
  
  class IncludeFilter
    def initialize to_retain
      @misses = [to_retain].flatten
    end
    
    def retain? build_type
      @misses.delete(build_type.id) || @misses.delete(build_type.name) ? true : false
    end
    
    def misses
      @misses
    end
  end
  
  class ExcludeFilter
    def initialize to_exclude
      @misses = [to_exclude].flatten
    end
    
    def retain? build_type
      @misses.delete(build_type.id) || @misses.delete(build_type.name) ? false : true
    end
    
    def misses
      @misses
    end
  end
  
  class Project
    
    attr_reader :teamcity, :name, :id, :href
    
    def initialize teamcity, name, id, href
      @teamcity, @name, @id, @href = teamcity, name, id, href
    end
    
    def build_types filter = {}
      including = filter.has_key?(:include) ? IncludeFilter.new(filter.delete(:include)) : IncludeAllFilter.new
      excluding = filter.has_key?(:exclude) ? ExcludeFilter.new(filter.delete(:exclude)) : ExcludeNoneFilter.new
      raise "Unsupported filter options #{filter}" unless filter.empty?
      build_types_for_project = teamcity.build_types.find_all { |bt| bt.project_id == id }
      filtered_build_types = build_types_for_project.find_all { |bt| including.retain?(bt) && excluding.retain?(bt) }
      raise "Failed to find a match for build type(s) #{including.misses}" if not including.misses.empty?
      raise "Failed to find a match for build type(s) #{excluding.misses}" if not excluding.misses.empty?
      filtered_build_types
    end
    
    def latest_builds filter = {}
      build_types(filter).collect(&:latest_build).reject(&:nil?)
    end
    
    def builds options = {}
      bt_ids = Set.new(build_types.collect(&:id))
      teamcity.builds(options).find_all { |b| bt_ids.include? b.build_type_id }
    end
  end
  
  BuildType = Struct.new(:teamcity, :id, :name, :href, :project_name, :project_id, :web_url) do
    def builds options = {}
      teamcity.builds({:buildType => "id:#{id}"}.merge(options))
    end
    def latest_build
      builds(:count => 1)[0]
    end
  end
  
  Build = Struct.new(:teamcity, :id, :number, :status, :build_type_id, :start_date, :href, :web_url) do
    def success?
      status == :SUCCESS
    end
  end
  
  class Authentication
  
  	def initialize openuri_options
  		@openuri_options = openuri_options
  	end 

    def get path, params = {}
      open(url(path, params), @openuri_options).read
    end

    def query_string_for params
      pairs = []
      params.each_pair { |k,v| pairs << "#{k}=#{v}" }
      pairs.join("&")
    end
  end

  class HttpBasicAuthentication < Authentication
  
    def initialize host, port, user, password, openuri_options = {}
    	super({:http_basic_authentication => [user, password]}.merge(openuri_options))
      @host, @port, @user, @password = host, port, user, password
    end

    def url path, params = {}
      auth_path = path.start_with?("/httpAuth/") ? path : "/httpAuth#{path}"
      query_string = !params.empty? ? "?#{query_string_for(params)}" : ""
      "http://#{@host}:#{@port}#{auth_path}#{query_string}"
    end  
    
    def to_s
      "HttpBasicAuthentication #{@user}:#{@password}"
    end
  end

  class Open < Authentication
  
    def initialize host, port, options = {}
    	super(options)
      @host, @port = host, port
    end

    def url path, params = {}
      query_string = !params.empty? ? "?#{query_string_for(params)}" : ""
      "http://#{@host}:#{@port}#{path}#{query_string}"
    end
    
    def to_s
      "No Authentication"
    end
  end
end

class REXML::Element
  def av name
    attribute(name).value
  end
  
  def av_or name, otherwise
    att = attribute(name) 
    att ? att.value : otherwise
  end
end

class Teamcity
  
  attr_reader :host, :port, :authentication
  
  def initialize host, port, options = {}
    @host, @port = host, port
    if options[:user] && options[:password]
      @authentication = TeamcityRestClient::HttpBasicAuthentication.new(host, port, options.delete(:user), options.delete(:password), options)
    else
      @authentication = TeamcityRestClient::Open.new(host, port, options)
    end
  end
  
  def project spec
    field = spec =~ /project\d+/ ? :id : :name  
    project = projects.find { |p| p.send(field) == spec }
    raise "Sorry, cannot find project with name or id '#{spec}'" unless project
    project
  end
  
  def projects
    doc(get('/app/rest/projects')).elements.collect('//project') do |e| 
      TeamcityRestClient::Project.new(self, e.av("name"), e.av("id"), url(e.av("href")))
    end
  end
  
  def build_types
    doc(get('/app/rest/buildTypes')).elements.collect('//buildType') do |e| 
      TeamcityRestClient::BuildType.new(self, e.av("id"), e.av("name"), url(e.av("href")), e.av('projectName'), e.av('projectId'), e.av('webUrl'))
    end
  end
  
  def builds options = {}
    doc(get('/app/rest/builds', options).gsub(/&buildTypeId/,'&amp;buildTypeId')).elements.collect('//build') do |e|
      TeamcityRestClient::Build.new(self, e.av('id'), e.av('number'), e.av('status').to_sym, e.av('buildTypeId'), e.av_or('startDate', ''), url(e.av('href')), e.av('webUrl'))
    end
  end
  
  def to_s
    "Teamcity @ #{url("/")}"
  end

  private
  def doc string
    REXML::Document.new string
  end

  def get path, params = {}
    result = @authentication.get(path, params)
    raise "Teamcity returned html, perhaps you need to use authentication??" if result =~ /.*<html.*<\/html>.*/im
    result
  end
  
  def url path
    @authentication.url(path)
  end
end
