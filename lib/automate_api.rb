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

  def self.setup(**opts)
    AutomateApi::Config.from_hash(opts)
    client.reload
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

  def self.load_config(config = %w{ ./.automate_api.rb ~/.automate_api.rb })
    config_loaded = false

    # make sure it's an Array
    config = Array(config)

    config.each do |config_file|
      c = File.expand_path(config_file)
      if File.exist?(c)
        AutomateApi::Config.from_file(c)
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
require "automate_api/models/compliance_node"
require "automate_api/models/compliance_report"
require "automate_api/models/node"
require "automate_api/models/node_run"
require "automate_api/models/node_manager"
require "automate_api/models/secret"
require "automate_api/models/scan_job"

# AutomateApi.load_config
