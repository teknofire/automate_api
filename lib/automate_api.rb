require 'hashie'
require 'httparty'
require 'mustache'
require "automate_api/version"
require "automate_api/config"
require "automate_api/helpers"
require "automate_api/output"


require "automate_api/client"
require "automate_api/resource/endpoint"
require "automate_api/resource/attributes"
require "automate_api/resource/base"

module AutomateApi
  class Error < StandardError; end
  class ResponseError < StandardError
    def initialize(request, method, message)
      super "[#{request.code}:#{request.message} - #{method.upcase}] #{message}"
    end
  end
  class RequestError < StandardError; end

  class Logger
    include AutomateApi::Output
  end

  def self.client
    @client ||= Client.new
  end

  def self.logger
    @logger ||= AutomateApi::Logger
  end

  def self.logger=(value)
    @logger = value
  end

  def self.configure(config = nil)
    config_loaded = false

    if config.nil?
      configs = %w{ ./.a2_cli.rb ~/.a2_cli.rb }
    else
      configs = [config]
    end

    configs.each do |config|
      config = File.expand_path(config)
      if File.exist?(config)
        AutomateApi::Config.from_file(config)
        config_loaded = true
        break
      end
    end

    if !config_loaded
      logger.warn "Could not find any config files, using defaults. (Tried: #{configs.join(', ')})"
    end

    # Tell the client to reload it's configs
    client.reload
  end
end

require "automate_api/models/user"
require "automate_api/models/team"
require "automate_api/models/token"
require "automate_api/models/compliance_profile"

AutomateApi.configure
