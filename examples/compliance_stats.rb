require 'automate_api'
require 'yaml'

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# logger.info 'Fetching nodes'
reports = AutomateApi::Models::ComplianceStats.summary

puts reports.to_yaml
