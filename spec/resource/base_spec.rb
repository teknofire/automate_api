require 'automate_api'

describe AutomateApi::Resource::Base do
  before do
    AutomateApi::Config.reset
    AutomateApi::Config.ssl_verify = false
    AutomateApi::Config.automate_url = 'https://test.test'
    AutomateApi::Config.auth_token = 'test_token'
  end

  
end
