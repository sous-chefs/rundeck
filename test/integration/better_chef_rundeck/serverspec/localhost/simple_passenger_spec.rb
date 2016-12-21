require 'spec_helper'

describe 'better-chef-rundeck' do
  context "when request is made to server" do
    it 'is up and running' do
      uri = URI('http://localhost:4000')
      res = Net::HTTP.get_response(uri)
      expect(res.code).to eq('200')
      expect(res.body).to eq("better-chef-rundeck is up and running!\nchef_config: /etc/chef/rundeck.rb\n")
    end
  end

  context "when request is made to server with \'*:*\' search query" do
    it 'returns all nodes from chef server' do
      uri = URI('http://localhost:4000/*:*')
      res = Net::HTTP.get_response(uri)
      expect(res.code).to eq('200')
      expect(res.body).to contain('bcr-node')
      expect(res.body).to contain('node-1')
      expect(res.body).to contain('node-2')
    end
  end

  context 'when request is made to server with specific search query' do
    it 'returns nodes which satisfies search query' do
      uri = URI('http://localhost:4000/chef_environment:env_one?ipaddress&fqdn&deep_attr=deep,nested,attribute')
      res = Net::HTTP.get_response(uri)
      expect(res.code).to eq('200')
      expect(res.body).to contain('deep_attr: 0')
      expect(res.body).to contain('fqdn')
      expect(res.body).to contain('node-1')
      expect(res.body).to contain('ipaddress')
      expect(res.body).not_to contain('node-2')
    end
  end
end
