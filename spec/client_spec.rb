require 'automate_api'

describe AutomateApi::Client do
  before do
    AutomateApi::Config.reset
    AutomateApi::Config.ssl_verify = false
    AutomateApi::Config.automate_url = 'https://test.test'
    AutomateApi::Config.auth_token = 'test_token'
  end

  context 'defaults' do
    let(:client) { AutomateApi::Client.new }
    let(:response) do
      response = double
      allow(response).to receive(:success?).and_return(true)
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:parsed_response).and_return({ 'test' => "data" })

      response
    end
    let(:request_opts) do
      {
        headers: {
          "api-token"=>"test_token",
          "content-type"=>"application/json"
        },
        verify: false
      }
    end

    it 'should get data' do
      expect(client.class).to receive(:get).with('/test', request_opts).and_return(response)
      expect(client.api_exec(:get, '/test')).to eq({ 'test' => "data" })
    end
  end
end
