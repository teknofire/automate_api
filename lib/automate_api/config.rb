require 'mixlib/config'

module AutomateApi
  module Config
    extend Mixlib::Config

    default :url, 'https://localhost'
    default :token, ''
    default :debug, false
    default :ssl_verify, true
  end
end
