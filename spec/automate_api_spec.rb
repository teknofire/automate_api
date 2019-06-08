require 'automate_api'

describe AutomateApi::Client do
  before do
    AutomateApi::Config.reset
    AutomateApi::Config.ssl_verify = false
    AutomateApi::Config.automate_url = 'https://test.test'
    AutomateApi::Config.auth_token = 'test_token'
  end

  context 'defaults' do
    it 'should have a client' do
      expect(AutomateApi.client).to be_an(AutomateApi::Client)
    end
  end
end
