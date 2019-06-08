require 'mixlib/config'

module AutomateApi
  module Config
    extend Mixlib::Config

    default :automate_url, 'https://localhost'
    default :auth_token, ''
    default :debug, false
    default :ssl_verify, true
  end
end
