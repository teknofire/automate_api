require 'hashie'
require 'httparty'
require 'mustache'
require "automate_api/version"
require "automate_api/config"
require "automate_api/helpers"
require "automate_api/ui"

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
require "automate_api/resource/base"
require "automate_api/resource/user"
require "automate_api/resource/team"

module AutomateApi
  class Error < StandardError; end
  class RequestError < StandardError; end
  class QueryNotSupported < StandardError
    def initialize(query, klass)
      super "Undefined api query '#{query}' for #{klass}.queries"
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
