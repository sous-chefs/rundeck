require 'spec_helper'

describe Hash do
  describe '#recursive' do
    let(:hsh) { Hash.recursive }
    it 'unset keys return an empty hash' do
      expect(hsh['a']['b']).to be_a(Hash)
      expect(hsh['a']['b']).to be_empty
    end
    it 'sets keys even when their parent is unset' do
      hsh['a']['b'] = 'c'
      expect(hsh['a']['b']).to eql('c')
    end
  end
end
