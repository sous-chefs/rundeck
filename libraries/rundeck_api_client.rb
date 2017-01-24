require 'json'
require 'net/http'
require 'openssl'

class RundeckApiClient
  def initialize(rundeck_server_url, user, pass, opts={})
    @rundeck_server_url, @user, = rundeck_server_url, user

    # convert all opts keys to symbols
    @opts = opts.each_with_object({}) { |(k,v), h| h[k.to_sym] = v }

    # the api only responds to authenticated clients, so call it from the constructor
    authenticate(pass)
  end

  # POST auth GET params to auth endpoint
  def authenticate(pass)
    req = Net::HTTP::Post.new(
      [
        '/j_security_check',
        URI('').query = URI.encode_www_form(j_username: @user, j_password: pass)
      ].join('?')
    )
    send_req(req)
  end

  def prep_req(req)
    req['User-Agent'] = 'RundeckApiClient'
    req['Content-Type'] = 'application/json'
    req['Accept'] = 'application/json'
    req['Cookie'] = @cookie
    req
  end

  def send_req(req)
    res = http.request(prep_req(req))

    # set cookie based on Set-Cookie header from server
    set_cookie(res)

    case res
    when Net::HTTPSuccess
      res
    when Net::HTTPRedirection
      # TODO: protect against redirect loops
      send_req(Net::HTTP::Get.new(res['location']))
    when Net::HTTPClientError, Net::HTTPServerError
      # Chef::Log.fatal "CODE: #{res.code} PATH: #{path_from_req(req)} BODY: #{res.body[0..250]}"
      raise res.error!
    end
  end

  def get(path)
    parse_res(send_req(Net::HTTP::Get.new(path)))
  end

  # def post(path, payload: {})
  #   req = Net::HTTP::Post.new(path)
  #   req.set_form_data(payload)
  #   parse_res(send_req(req))
  # end

  def parse_res(res)
    JSON.parse(res.body)
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
end
