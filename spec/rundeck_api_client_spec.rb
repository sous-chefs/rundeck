require 'spec_helper'

describe RundeckApiClient do
  let(:http_dbl) { instance_double(Net::HTTP) }
  let(:client) do
    described_class.new('http://rundeck.url', 'username', 'S3cur3_P@55w0rd', 'verify_mode' => 0)
  end

  before do
    # authenticate is called from constructor, so stub it
    allow_any_instance_of(described_class).to receive(:authenticate)

    # dont send actual http requests
    allow(http_dbl).to receive(:request).and_return(instance_double(Net::HTTPSuccess))
    allow_any_instance_of(described_class).to receive(:http).and_return(http_dbl)
  end

  describe '#initialize' do
    it 'returns an authenticated api client' do
      expect_any_instance_of(described_class).to receive(:authenticate)

      expect(client).to be_an_instance_of(described_class)
      expect(client.instance_variable_get('@rundeck_server_url')).to eq('http://rundeck.url')
      expect(client.instance_variable_get('@user')).to eq('username')
      expect(client.instance_variable_get('@opts')).to eq(verify_mode: 0)
    end
  end

  describe '#authenticate' do
    it 'sends a POST to the auth endpoint with auth GET params' do
      expect(client).to receive(:send_req) do |auth_req|
        expect(auth_req).to be_an_instance_of(Net::HTTP::Post)
        expect(auth_req.path).to eql(
          '/j_security_check?j_username=username&j_password=S3cur3_P%4055w0rd'
        )
      end

      # unstub authenticate
      allow_any_instance_of(described_class).to receive(:authenticate).and_call_original

      client.authenticate('S3cur3_P@55w0rd')
    end
  end

  describe '#prep_req' do
    let(:reqs) do
      [
        Net::HTTP::Get.new('/path'),
        Net::HTTP::Post.new('/path'),
        Net::HTTP::Put.new('/path'),
        Net::HTTP::Delete.new('/path')
      ]
    end
    let(:cookie_string) { 'a=b; c=d' }
    before { client.instance_variable_set('@cookie', cookie_string) }

    it 'prepares a request object with headers' do
      reqs.each do |req|
        expect(client.prep_req(req).to_hash).to include(
          'accept' => ['application/json'],
          'content-type' => ['application/json'],
          'user-agent' => [described_class.name],
          'cookie' => [cookie_string]
        )
      end
    end
  end

  describe '#send_req' do
    before do
      allow(client).to receive(:http).and_return(double(request: res))
      allow(client).to receive(:prep_req)
      allow(client).to receive(:set_cookie)
    end

    context 'HTTP Success (2xx)' do
      let(:res) { instance_double(Net::HTTPSuccess) }

      it 'returns response object' do
        # case statement comparison uses === internally
        allow(Net::HTTPSuccess).to receive(:'===').and_return(true)

        expect(client).to receive(:http).and_return(double(request: res))
        expect(client).to receive(:prep_req)
        expect(client).to receive(:set_cookie)

        expect(client.send_req(double)).to eql(res)
      end
    end

    context 'HTTP Redirect (3xx)' do
      let(:initial_req) { double }
      let(:res) do
        dbl = instance_double(Net::HTTPRedirection)
        allow(dbl).to receive(:'[]').with('location').and_return('/redirect/path')
        dbl
      end

      it 'sends another request to the redirect response location' do
        allow(Net::HTTPRedirection).to receive(:'===').and_return(true)

        expect(client).to receive(:send_req).with(initial_req).and_call_original
        expect(Net::HTTP::Get).to receive(:new).with('/redirect/path').and_call_original
        expect(client).to receive(:send_req) do |redirect_req|
          expect(redirect_req).to be_an_instance_of(Net::HTTP::Get)
          expect(redirect_req.path).to eql(
            '/redirect/path'
          )
        end.once

        client.send_req(initial_req)
      end
    end

    context 'HTTP Client error (4xx)' do
      include_examples 'RundeckApiClient#send_req HTTP Error', Net::HTTPClientError
    end

    context 'HTTP Server error (5xx)' do
      include_examples 'RundeckApiClient#send_req HTTP Error', Net::HTTPServerError
    end
  end

  describe '#get' do
    let(:res) { double }

    it 'returns an object from the parsed HTTP response' do
      expect(Net::HTTP::Get).to receive(:new).with('/path').and_call_original
      expect(client).to receive(:send_req) do |redirect_req|
        expect(redirect_req).to be_an_instance_of(Net::HTTP::Get)
        expect(redirect_req.path).to eql(
          '/path'
        )
      end.and_return(res)
      expect(client).to receive(:parse_res).with(res)
      client.get '/path'
    end
  end

  describe '#parse_res' do
    let(:res) { double(body: '{"a": ["b", "c"]}') }

    it 'returns an object from the parse HTTP response' do
      expect(client.parse_res(res)).to eql('a' => ['b', 'c'])
    end
  end

  describe '#http' do
    before do
      # unstub http
      allow_any_instance_of(described_class).to receive(:http).and_call_original
    end

    context 'http server url' do
      it 'returns an HTTP connection object without ssl' do
        http = client.http
        expect(http.use_ssl?).to be false
        expect(http.verify_mode).to be_zero
        expect(http).to be_an_instance_of(Net::HTTP)
      end
    end

    context 'https server url' do
      it 'returns an HTTP connection object with ssl' do
        http = described_class.new('https://server.com', 'user', 'pass').http
        expect(http.use_ssl?).to be true
        expect(http.verify_mode).to eql(OpenSSL::SSL::VERIFY_PEER)
        expect(http).to be_an_instance_of(Net::HTTP)
      end
    end
  end

  describe '#set_cookie' do
    let(:res) do
      double(
        to_hash: {
          'set-cookie' => [
            'JSESSIONID=1aj2d3p8ys3x41817e6u9tyrwp;Path=/',
            'PersistCookie=!E9VRWf+g4qIUHYdd8YgsNgonASIzcTkLx9O/fUE4meVykULQxwCP3i4Ol6wH9+bzxzzqu8iWCI8iQDM=; path=/'
          ]
        }
      )
    end

    it 'sets the cookie instance variable based on the Set-Cookie HTTP header' do
      client.set_cookie(res)
      expect(client.instance_variable_get('@cookie')).to eql(
        'JSESSIONID=1aj2d3p8ys3x41817e6u9tyrwp; PersistCookie=!E9VRWf+g4qIUHYdd8YgsNgonASIzcTkLx9O/fUE4meVykULQxwCP3i4Ol6wH9+bzxzzqu8iWCI8iQDM='
      )
    end

    context 'Set-Cookie header not provided by server' do
      let(:res) { double(to_hash: { 'some-header' => 'some value' }) }
      it 'does not set the cookie instance variable' do
        expect(client.instance_variable_get('@cookie')).to be nil
      end
    end
  end

  describe '#path_from_req' do
    it 'provides a common interface to get a path from a Net::HTTPRequest' do
      ['/path', 'http://host.domain/path'].each do |location|
        expect(client.path_from_req(Net::HTTP::Get.new(location))).to eql('/path')
      end
    end
  end

  describe '#version' do
    it 'returns the rundeck server api version' do
      expect(client).to receive(:get).and_return(
        'system' => { 'rundeck' => { 'apiversion' => 18 } }
      )
      expect(client.version).to eql(18)
    end
  end
end
