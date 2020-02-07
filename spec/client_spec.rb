require 'automate_api'

describe AutomateApi::Client do
  context 'defaults' do
    let(:client) { AutomateApi::Client.new }
    let(:response) do
      response = double
      allow(response).to receive(:success?).and_return(true)
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:message).and_return('OK')
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

    it 'should have a logger' do
      expect(client.logger).to eq AutomateApi.logger
    end

    it 'should reload base_uri from config' do
      AutomateApi::Config.url = 'https://bad.test'
      AutomateApi.client.reload

      expect(AutomateApi.client.base_uri).to eq 'https://bad.test'
    end
  end
end
