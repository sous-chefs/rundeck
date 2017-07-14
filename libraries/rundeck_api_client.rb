require 'chef'
require 'json'

class Hash
  def symbolize_all_keys
    symbolized_hash = {}
    each do |k, v|
      key = k.respond_to?(:to_sym) ? k.to_sym : k
      value = v.is_a?(Hash) ? v.symbolize_all_keys : v
      symbolized_hash[key] = value
    end
    symbolized_hash
  end
end

class RundeckApiClient
  def initialize(server_url, username, config = {})
    # Lazily require dependencies so that the cookbook can install them first
    # via chef_gem
    require 'rest-client'

    @server_url = server_url
    @username = username

    # convert all config keys to symbols
    @config = config.symbolize_all_keys
  end

  # @return [RundeckApiClient] an authenticated client
  #
  # @example Connect an api client with max logging (Logger::DEBUG)
  #   RundeckApiClient.connect(
  #     'http://localhost:80',
  #     'admin',
  #     'adminpassword',
  #     log_level: 0,
  #     request_defaults: { verify_ssl: false }
  #   )
  def self.connect(server_url, username, password, opts = {})
    client = new(server_url, username, opts)
    client.authenticate(password)
    Chef::Log.info { "Connected new client: #{client}" }
    client
  end

  def authenticate(password)
    request(
      method: :post,
      url: File.join(@server_url, 'j_security_check'),
      headers: {
        params: { j_username: @username, j_password: password },
      }
    )
  end

  def get(path, params = {})
    request_wrapper(:get, path, params: params)
  end

  def delete(path, params = {})
    request_wrapper(:delete, path, params: params)
  end

  def post(path, payload)
    request_wrapper(:post, path, payload: payload)
  end

  def put(path, payload)
    request_wrapper(:put, path, payload: payload)
  end

  def request_wrapper(http_method, path, params: {}, payload: {})
    opts = {}
    opts[:method] = http_method
    opts[:url] = api_url(path)
    opts[:headers] = { params: params }
    opts[:payload] = payload.to_json unless payload.empty?

    Chef::Log.debug { "request_wrapper called with opts: #{opts}" }

    res = request(opts)

    if res.headers[:content_type] =~ /application\/json/i
      if res.body.to_s.empty?
        Chef::Log.warn { 'empty response body received' }
        res
      else
        JSON.parse(res.body)
      end
    else
      Chef::Log.warn do
        "received response content-type '#{res['content-type']}' (expected 'application/json')"
      end
      res
    end
  end

  # @see https://github.com/rest-client/rest-client
  # @see http://www.rubydoc.info/github/rest-client/rest-client/RestClient/Request
  def request(opts)
    opts = Chef::Mixin::DeepMerge.deep_merge(
      opts,
      request_defaults
    )

    begin
      RestClient::Request.execute(opts) { |res, req| response_handler(res, req) }
    rescue RestClient::MovedPermanently,
           RestClient::Found,
           RestClient::TemporaryRedirect => e
      e.response.follow_redirection { |res, req| response_handler(res, req) }
    end
  end

  def response_handler(res, req)
    @cookie_jar = res.cookie_jar

    # Simple logging format for all requests. Strip GET params (query) from
    # request url because login request puts password in GET param.
    uri = URI(req.url)
    uri.query = nil
    log = "#{res.code}\t#{req.method.upcase}\t#{uri}"

    case res.code
    when 200..299
      Chef::Log.info { log }
    when 301, 302, 307
      Chef::Log.info { log }
      res.follow_redirection { |redir_res, redir_req| response_handler(redir_res, redir_req) }
    when 400..599
      Chef::Log.warn { [log, 'BODY:', res.body].join(' ') }
    end

    # http://www.rubydoc.info/github/rest-client/rest-client/RestClient/AbstractResponse#return!-instance_method
    res.return!
  end

  # Merge generic api client defaults with the defaults the client was
  # initialized with, and return the merged hash.
  def request_defaults
    Chef::Mixin::DeepMerge.deep_merge(
      @config[:request_defaults].to_h,
      cookies: @cookie_jar,
      headers: {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'User-Agent' => self.class.name,
      }
    )
  end

  def server_uri
    @_server_uri ||= URI(@server_url)
  end

  # Handles various URIs to build a url. Defaults missing URI components using
  # server URI.
  # @return [String]
  def api_url(url)
    uri = URI(url.to_s)

    uri.scheme = server_uri.scheme if uri.scheme.nil?
    uri.host = server_uri.host if uri.host.nil?

    # prepend '/api/<version>/' to path if not provided
    unless uri.path =~ /^\/api\/\d+\//
      uri.path = File.join('/api', version.to_s, uri.path)
    end

    uri.to_s
  end

  # @return [Integer] server api version
  def version
    return @_version if defined? @_version
    res = get('/api/14/system/info')
    @_version = res['system']['rundeck']['apiversion']
  end
end
