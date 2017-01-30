require 'json'
require 'logger'
require 'net/http'
require 'openssl'

class RundeckApiClient
  def initialize(rundeck_server_url, user, opts={})
    @rundeck_server_url, @user, = rundeck_server_url, user
    # convert all opts keys to symbols
    @opts = opts.each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
  end

  # POST auth GET params to auth endpoint
  def authenticate(pass)
    send_req(
      Net::HTTP::Post.new(
        [
          '/j_security_check',
          URI.encode_www_form(j_username: @user, j_password: pass)
        ].join('?')
      )
    )
  end

  # wrapper around constructor and authentication
  # nothing can be done via the api without authenticating, so this method is
  # the preferred way to initialize a client
  def self.connect(rundeck_server_url, user, pass, opts={})
    client = new(rundeck_server_url, user, opts)
    client.authenticate(pass)
    client
  end

  def prep_req(req)
    req['User-Agent'] = self.class.name
    req['Content-Type'] = 'application/json'
    req['Accept'] = 'application/json'
    req['Cookie'] = @cookie
    req
  end

  def send_req(req)
    res = http.request(prep_req(req))

    # set cookie based on Set-Cookie header from server
    set_cookie(res)

    log = "Response received: CODE: #{res.code} PATH: #{path_from_req(req)}"

    case res
    when Net::HTTPSuccess
      logger.info log
      res
    when Net::HTTPRedirection
      logger.info log
      # TODO: protect against redirect loops
      send_req(Net::HTTP::Get.new(res['location']))
    when Net::HTTPClientError, Net::HTTPServerError
      logger.warn(log + " BODY: #{res.body[0..250]}")
      raise res.error!
    end
  end

  def request(klass, path, query: {}, payload: {})
    path = api_path(path)

    unless query.empty?
      path = [path, URI.encode_www_form(query)].join('?')
    end

    req = klass.new(path)

    unless payload.empty?
      req.body = payload.to_json
    end

    parse_res(send_req(req))
  end

  def logger
    return @_logger if defined? @_logger
    @_logger = Logger.new(STDOUT)
    @_logger.level = @opts[:log_level] || Logger::INFO
    @_logger.progname = self.class.name
    @_logger
  end

  def get(path, query={})
    request(Net::HTTP::Get, path, query: query)
  end

  def post(path, payload)
    request(Net::HTTP::Post, path, payload: payload)
  end

  def put(path, payload)
    request(Net::HTTP::Put, path, payload: payload)
  end

  def post_or_put(path, payload)
    begin
      post(path, payload)
    rescue Net::HTTPServerException => e
      if e.message == '409 "Conflict"'
        put(path, payload)
      else
        raise e
      end
    end
  end

  def delete(path)
    request(Net::HTTP::Delete, path)
  end

  def parse_res(res)
    if res['content-type'] =~ /application\/json/i
      if res.body.to_s.empty?
        logger.warn 'empty response body received'
        nil
      else
        JSON.parse(res.body.to_s)
      end
    else
      logger.warn(
        "received response content-type '#{res['content-type']}' (expected 'application/json')"
      )
      nil
    end
  end

  def http
    return @_http if defined? @_http
    uri = URI(@rundeck_server_url)
    @_http = Net::HTTP.new(uri.host, uri.port)
    @_http.use_ssl = (uri.scheme == "https")
    @_http.verify_mode = @opts[:verify_mode] || OpenSSL::SSL::VERIFY_PEER
    @_http
  end

  def set_cookie(res)
    # simple implementation to parse cookie string
    if res.to_hash.key?('set-cookie')
      @cookie = res.to_hash['set-cookie'].map{ |c| c.split(';').first }.join('; ')
    end
  end

  # Common interface to get a path from a request that Net::HTTPRequest does not provide:
  #     Net::HTTP::Get.new('/path').path
  #     #=> "/path"
  #     Net::HTTP::Get.new('https://host.com/path').path
  #     #=> "https://host.com/path"
  def path_from_req(req)
    URI(req.path).path
  end

  def version
    @_version ||= get('/api/14/system/info')['system']['rundeck']['apiversion']
  end

  # prepend /api/<version> to path unless its provided already
  def api_path(path)
    path = URI(path).path
    case path
    when /^\/?api\/\d+/
      path
    else
      File.join '/api', version.to_s, path
    end
  end
end
