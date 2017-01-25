require 'spec_helper'

describe Hash do
  describe '#recursive' do
    hsh = Hash.recursive
    expect(hsh['a']['b']).to be nil
    hsh['a']['b'] = 'c'
    expect(hsh['a']['b']).to eql('c')
  end
end
