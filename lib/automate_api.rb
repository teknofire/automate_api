require 'hashie'
require 'httparty'
require 'mustache'
require "automate_api/version"
require "automate_api/config"
require "automate_api/helpers"
require "automate_api/output"

config_loaded = false
configs = %w{ ./.a2_cli.rb ~/.a2_cli.rb }

configs.each do |config|
  config = File.expand_path(config)
  if File.exist?(config)
    AutomateApi::Config.from_file(config)
    config_loaded = true
    break
  end
end

if !config_loaded
  # A2::UI.warn "Could not find any config files, using defaults. (Tried: #{configs.join(', ')})"
end

require "automate_api/client"
require "automate_api/resource/endpoint"
require "automate_api/resource/attributes"
require "automate_api/resource/base"
require "automate_api/models/user"
require "automate_api/models/team"
require "automate_api/models/token"

module AutomateApi
  class Error < StandardError; end
  class RequestError < StandardError;
    def initialize(request, method, message)
      super "[#{request.code}:#{request.message} - #{method.upcase}] #{message}"
    end
  end

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
end
