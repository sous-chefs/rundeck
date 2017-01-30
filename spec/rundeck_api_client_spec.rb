require 'spec_helper'

describe RundeckApiClient do
  let(:rundeck_server_url) { 'http://rundeck.url' }
  let(:client) do
    described_class.new(rundeck_server_url, 'username', 'verify_mode' => 0)
  end

  describe '#initialize' do
    it 'returns an api client' do
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
      client.authenticate('S3cur3_P@55w0rd')
    end
  end

  describe "#{described_class.name}#connect" do
    it 'returns an authenticated api client' do
      expect(described_class).to receive(:new).with(rundeck_server_url, 'user', a: 'A').and_call_original
      expect_any_instance_of(described_class).to receive(:authenticate).with('pass')
      expect(
        described_class.connect(rundeck_server_url, 'user', 'pass', a: 'A')
      ).to be_an_instance_of(described_class)
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
      allow(client).to receive(:path_from_req).and_return('/path')
    end

    context 'HTTP Success (2xx)' do
      let(:res) { instance_double(Net::HTTPSuccess, code: 200) }

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
        dbl = instance_double(Net::HTTPRedirection, code: 302)
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
      let(:res) { instance_double(Net::HTTPClientError, code: 403) }

      it 'raises correct HTTP error' do
        allow(Net::HTTPClientError).to receive(:'===').and_return(true)
        expect { client.send_req(double) }.to raise_error(Net::HTTPClientError)
      end
    end

    context 'HTTP Server error (5xx)' do
      let(:res) { instance_double(Net::HTTPServerError, code: 500) }

      it 'raises correct HTTP error' do
        allow(Net::HTTPServerError).to receive(:'===').and_return(true)
        expect { client.send_req(double) }.to raise_error(Net::HTTPServerError)
      end
    end
  end

  describe '#request' do
    before do
      allow(client).to receive(:api_path).and_return('/path')
    end
    let(:res) do
      res = double(body: '{"a": ["b", "c"]}')
      allow(res).to receive(:[]).with('content-type').and_return('application/JSON;charset=UTF-8')
      res
    end

    context 'no query provided' do
      context 'no payload provided' do
        it 'sends a request and returns the parsed response' do
          expect(client).to receive(:send_req) do |req|
            expect(req).to be_an_instance_of(Net::HTTP::Post)
            expect(req.body).to be nil
            expect(req.path).to eql('/path')
          end.and_return(res)
          expect(client).to receive(:parse_res).and_call_original

          expect(client.request(Net::HTTP::Post, '/path')).to eql(
            { 'a' => ['b', 'c'] }
          )
        end
      end

      context 'payload provided' do
        let(:payload) { { x: 'X', y: 'Y' } }

        it 'sends a request and returns the parsed response' do
          expect(client).to receive(:send_req) do |req|
            expect(req).to be_an_instance_of(Net::HTTP::Post)
            expect(req.body).to eql('{"x":"X","y":"Y"}')
            expect(req.path).to eql('/path')
          end.and_return(res)
          expect(client).to receive(:parse_res).and_call_original

          expect(client.request(Net::HTTP::Post, '/path', payload: payload)).to eql(
            { 'a' => ['b', 'c'] }
          )
        end
      end
    end

    context 'query provided' do
      let(:query) { { a: 'A', b: 'B' } }

      context 'no payload provided' do
        it 'sends a request and returns the parsed response' do
          expect(client).to receive(:send_req) do |req|
            expect(req).to be_an_instance_of(Net::HTTP::Post)
            expect(req.body).to be nil
            expect(req.path).to eql('/path?a=A&b=B')
          end.and_return(res)
          expect(client).to receive(:parse_res).and_call_original

          expect(client.request(Net::HTTP::Post, '/path', query: query)).to eql(
            { 'a' => ['b', 'c'] }
          )
        end
      end

      context 'payload provided' do
        let(:payload) { { x: 'X', y: 'Y' } }
        it 'sends a request and returns the parsed response' do
          expect(client).to receive(:send_req) do |req|
            expect(req).to be_an_instance_of(Net::HTTP::Post)
            expect(req.body).to eql('{"x":"X","y":"Y"}')
            expect(req.path).to eql('/path?a=A&b=B')
          end.and_return(res)
          expect(client).to receive(:parse_res).and_call_original

          expect(client.request(
            Net::HTTP::Post,
            '/path',
            query: query,
            payload: payload
          )).to eql(
            { 'a' => ['b', 'c'] }
          )
        end
      end
    end
  end

  describe '#get' do
    it 'sends a GET with a query' do
      expect(client).to receive(:request).with(
        Net::HTTP::Get,
        '/path',
        query: { a: 'A', b: 'B' }
      )
      client.get('/path', a: 'A', b: 'B')
    end
  end

  describe '#post' do
    it 'sends a POST with a payload' do
      expect(client).to receive(:request).with(
        Net::HTTP::Post,
        '/path',
        payload: { a: 'A', b: 'B' }
      )
      client.post('/path', a: 'A', b: 'B')
    end
  end

  describe '#put' do
    it 'sends a PUT with a payload' do
      expect(client).to receive(:request).with(
        Net::HTTP::Put,
        '/path',
        payload: { a: 'A', b: 'B' }
      )
      client.put('/path', a: 'A', b: 'B')
    end
  end

  describe '#delete' do
    it 'sends a DELETE' do
      expect(client).to receive(:request).with(Net::HTTP::Delete, '/path')
      client.delete('/path')
    end
  end

  describe '#post_or_put' do
    before do
      allow(client).to receive(:set_cookie)
    end

    let(:payload) { { a: 'A', b: 'B' } }

    context 'resource does not exist' do
      it 'sends a POST with a payload' do
        expect(client).to receive(:post).with(
          '/path',
          payload
        )
        expect(client).to_not receive(:put)
        client.post_or_put('/path', payload)
      end
    end

    context 'resource exists' do
      context 'POST response is 409 Conflict' do
        it 'sends a PUT with a payload' do
          skip 'figuring out how to raise Net::HTTPServerException'
          # skipping is acceptable here because I validate this functionality
          # in kitchen tests

          expect(client).to receive(:post).with(
            '/path',
            payload
          ).and_raise(Net::HTTPServerException)

          expect(client).to receive(:put).with(
            '/path',
            payload
          )
          client.post_or_put('/path', payload)
        end
      end

      context 'POST response is some other error' do
        it 'raises the error' do
          skip 'figuring out how to raise Net::HTTPServerException'
          # skipping is acceptable here because I validate this functionality in kitchen tests

          expect(client).to receive(:post).with(
            '/path',
            payload
          ).and_raise(Net::HTTPServerException)

          expect { client.post_or_put('/path', payload) }.to raise_error(Net::HTTPServerException)
        end
      end
    end
  end

  describe '#parse_res' do
    let(:res) do
      res = double(body: body)
      allow(res).to receive(:[]).with('content-type').and_return(content_type)
      res
    end

    context 'content type is application/json' do
      let(:content_type) { 'application/json' }

      context 'response body is empty' do
        let(:body) { '' }

        it 'returns nil' do
          expect(client.parse_res(res)).to be nil
        end
      end

      context 'response body is json' do
        let(:body) { '{"a": ["b", "c"]}' }

        it 'returns the parsed json' do
          expect(client.parse_res(res)).to eql({ 'a' => ['b', 'c'] })
        end
      end
    end

    context 'response body is not json' do
      let(:content_type) { 'text/html' }
      let(:body) { '<!DOCTYPE html><html><body></body></html>' }

      it 'returns nil' do
        expect(client.parse_res(res)).to be nil
      end
    end
  end

  describe '#http' do
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
        http = described_class.new('https://server.com', 'user').http
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

  describe '#api_path' do
    it 'prepends the api root with current version unless its provided already' do
      allow(client).to receive(:version).and_return(14)
      expect(client.api_path('http://rundeck.url/project/test-proj')).to eq(
        '/api/14/project/test-proj'
      )
      expect(client.api_path('http://rundeck.url/api/14/project/test-proj')).to eq(
        '/api/14/project/test-proj'
      )
      expect(client.api_path('http://rundeck.url/users')).to eq('/api/14/users')
      expect(client.api_path('http://rundeck.url/api/14/users')).to eq('/api/14/users')

      expect(client.api_path('project/test-proj')).to eq('/api/14/project/test-proj')
      expect(client.api_path('api/14/project/test-proj')).to eq('api/14/project/test-proj')
      expect(client.api_path('/users')).to eq('/api/14/users')
      expect(client.api_path('/api/14/users')).to eq('/api/14/users')
    end
  end

  describe '#logger' do
    context 'log level not specified' do
      it 'returns the configured logger' do
        logger = client.logger
        expect(logger).to be_an_instance_of(Logger)
        expect(logger.level).to eql(Logger::INFO)
        expect(logger.progname).to eql(described_class.name)
      end
    end

    context 'log level specified' do
      let(:client) do
        described_class.new(rundeck_server_url, 'username', 'log_level' => 3)
      end

      it 'returns the configured logger' do
        logger = client.logger
        expect(logger).to be_an_instance_of(Logger)
        expect(logger.level).to eql(Logger::ERROR)
        expect(logger.progname).to eql(described_class.name)
      end
    end
  end
end
