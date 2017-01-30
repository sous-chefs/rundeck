require 'spec_helper'

describe RundeckHelper do
  describe '#generateuuid' do
    let(:uuid) { 'c5f54c42-7444-4a9e-8bd8-ccd29650b2ad' }

    it 'returns a uuid from securerandom' do
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
      expect(described_class.generateuuid).to eql(uuid)
    end
  end
end
