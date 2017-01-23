shared_examples 'RundeckApiClient#send_req HTTP Error' do |http_error_class|
  let(:res) { instance_double(http_error_class) }

  it 'raises correct HTTP error' do
    allow(http_error_class).to receive(:'===').and_return(true)
    expect { client.send_req(double) }.to raise_error(http_error_class)
  end
end
