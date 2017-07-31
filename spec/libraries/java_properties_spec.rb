require 'spec_helper'

describe Hash do
  let(:properties) do
    {
      'a' => 'b',
      'c.4' => {
        :blue => false,
        'purple' => {
          11 => '14',
        },
        '11.12' => 'http://rundeck.url/A=B&C=D',
      },
      '_' => '!@#$%^&*()',
    }
  end

  describe '#to_java_properties_hash' do
    it 'returns a java properties hash' do
      expect(properties.to_java_properties_hash).to eql('_' => "!@\#$%^&*()",
                                                        'a' => 'b',
                                                        'c.4.11.12' => 'http://rundeck.url/A=B&C=D',
                                                        'c.4.blue' => 'false',
                                                        'c.4.purple.11' => '14')
    end

    it 'can be called multiple times and return the same result' do
      expect(properties.to_java_properties_hash).to eql(
        properties.to_java_properties_hash.to_java_properties_hash
      )
    end

    it 'returns a hash sorted by key' do
      expect({ c: 'd', a: 'b' }.to_java_properties_hash.keys).to eql(%w(a c))
      expect({ c: 'd', a: 'b' }.to_java_properties_hash.keys).to_not eql(%w(c a))
    end
  end

  describe '#to_java_properties_lines' do
    it 'returns java properties file lines' do
      expect(properties.to_java_properties_lines).to eql([
                                                           "_=!@\#$%^&*()",
                                                           'a=b',
                                                           'c.4.11.12=http\\://rundeck.url/A\\=B&C\\=D',
                                                           'c.4.blue=false',
                                                           'c.4.purple.11=14',
                                                         ])
    end
  end

  describe '#to_java_properties_string' do
    it 'returns java properties file content' do
      expect(properties.to_java_properties_string).to eql(
        '_=!@#$%^&*()
a=b
c.4.11.12=http\://rundeck.url/A\=B&C\=D
c.4.blue=false
c.4.purple.11=14'
      )
    end
  end
end
