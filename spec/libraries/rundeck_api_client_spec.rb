require 'spec_helper'

describe Hash do
  describe '#symbolize_all_keys' do
    let(:hsh) do
      {
        'a' => true,
        'b' => {},
        'c' => {
          false => 4,
          d: 'D',
          'e' => { 'a' => 'b' },
        },
        d: 'blue',
        'e' => 'green',
      }
    end

    it 'symbolizes all keys recursively' do
      expect(hsh.symbolize_all_keys).to eq(
        a: true,
        b: {},
        c: {
          false => 4,
          d: 'D',
          e: { a: 'b' },
        },
        d: 'blue',
        e: 'green'
      )
    end
  end
end

describe RundeckApiClient do
  let(:server_url) { 'https://rundeck.domain.com' }
  let(:client) do
    described_class.new(
      server_url,
      'username',
      'request_defaults' => { verify_ssl: false }
    )
  end

  describe '#initialize' do
    it 'returns a new instance of the class' do
      expect_any_instance_of(described_class).to receive(:require).with('rest-client')
      expect(client.instance_variable_get('@server_url')).to eq(server_url)
      expect(client.instance_variable_get('@config')).to eq(
        request_defaults: { verify_ssl: false }
      )
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#connect' do
    let(:client) do
      double(
        described_class.name,
        authenticate: double
      )
    end

    it 'connects to the api' do
      expect(described_class).to receive(:new).with(
        server_url,
        'username',
        a: 'A'
      ).and_return(client)
      expect(client).to receive(:authenticate).with('password')
      described_class.connect(server_url, 'username', 'password', a: 'A')
    end
  end

  describe '#authenticate' do
    it 'sends the POST auth request' do
      expect(client).to receive(:request).with(method: :post,
                                               url: "#{server_url}/j_security_check",
                                               headers: {
                                                 params: { j_username: 'username', j_password: 'password' },
                                               })
      client.authenticate('password')
    end
  end

  describe '#request_defaults' do
    context 'no request defaults provided in client initialization' do
      let(:client) { described_class.new(server_url, 'username') }

      it "returns the client's default request options" do
        expect(client.request_defaults).to eq(
          cookies: nil,
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
            'User-Agent' => described_class.name,
          }
        )
      end
    end

    context 'request defaults provided in client initialization' do
      it "returns the client's default request options" do
        expect(client.request_defaults).to eq(cookies: nil,
                                              headers: {
                                                'Accept' => 'application/json',
                                                'Content-Type' => 'application/json',
                                                'User-Agent' => described_class.name,
                                              },
                                              verify_ssl: false)
      end
    end

    context 'cookies already set' do
      it "returns the client's default request options" do
        client.instance_variable_set('@cookie_jar', 'cookie' => 'hash')
        expect(client.request_defaults).to eq(cookies: { 'cookie' => 'hash' },
                                              headers: {
                                                'Accept' => 'application/json',
                                                'Content-Type' => 'application/json',
                                                'User-Agent' => described_class.name,
                                              },
                                              verify_ssl: false)
      end
    end
  end

  describe '#response_handler' do
    let(:cookie_jar) { instance_double(HTTP::CookieJar) }
    let(:res) { double(cookie_jar: cookie_jar, code: code) }

    let(:url) { File.join(server_url, '/path') }
    let(:http_method) { :get }
    let(:req) { double(url: url, method: http_method) }

    context '2xx' do
      let(:code) { 200 }

      it 'returns the response' do
        expect(Chef::Log).to receive(:info)
        expect(res).to receive(:return!)
        client.response_handler(res, req)
      end
    end
  end

  describe '#request' do
    let(:url) { 'https://rundeck.domain.com/path' }
    let(:return_obj) { double }
    let(:res) { double('response') }
    let(:req) { double('request') }
    let(:result) { double('result') }

    context 'http success' do
      it 'default block is passed to RestClient::Request' do
        expect(client).to receive(:request_defaults).and_return({}).at_least(:once)

        expect(RestClient::Request).to receive(:execute).with(
          url: url, method: :get
        ).and_yield(res, req)

        # the default request handler is called
        expect(client).to receive(:response_handler).with(res, req).and_return(return_obj)

        expect(
          client.request(url: url, method: :get)
        ).to eq(return_obj)
      end
    end

    context 'http redirect' do
      # the response from the initial request
      let(:res) { double('RestClient::MovedPermanently') }
      # the response from the redirect
      let(:redirect_res) { double }
      # the err returned with the exception
      let(:err) { double(response: res) }

      it 'original 3XX response receives follow_redirection' do
        skip 'figuring out how to raise RestClient::MovedPermanently and test logic in rescue'

        # original request responds with a redirect
        expect(RestClient::Request).to receive(:execute).and_raise(
          RestClient::MovedPermanently,
          err
        )

        # following the redirect yields objects to a block
        expect(res).to receive(:follow_redirection).and_yield(redirect_res, req)

        # the handler method in the request block does something with the objects
        expect(client).to receive(:response_handler).and_return(return_obj)

        # the whole method returns what is returned by the request block
        expect(
          client.request(url: url, method: :get)
        ).to eq(return_obj)
      end
    end
  end

  describe '#server_uri' do
    it 'returns a URI object for the server url' do
      uri = client.server_uri
      expect(uri).to be_a(URI)
      expect(uri.to_s).to eq(server_url)
    end
  end

  describe '#api_url' do
    before { allow(client).to receive(:version).and_return(15) }

    context 'receives only path' do
      let(:url) { '/api/14/users' }

      it 'defaults host and scheme to server url' do
        expect(client.api_url(url)).to eq(File.join(server_url, url))
      end

      context "path does not include '/api/<version>'" do
        let(:url) { '/project/test-project' }

        it 'prepends the api root and version to the path' do
          expect(client.api_url(url)).to eq(File.join(server_url, '/api/15/project/test-project'))
        end
      end
    end

    context 'full url provided' do
      let(:url) { 'https://rundeck.net/api/12/plugins' }

      it 'does not modify the url' do
        expect(client.api_url(url)).to eq(url)
      end
    end
  end

  describe '#version' do
    it 'retrieve the api version from the api' do
      expect(client).to receive(:get).and_return(
        'system' => { 'rundeck' => { 'apiversion' => 16 } }
      )
      expect(client.version).to eq(16)
    end
  end
end
