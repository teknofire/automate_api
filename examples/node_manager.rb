require 'automate_api'
require 'yaml'

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

logger.info 'Fetching NodeManager'
managers = AutomateApi::Models::NodeManager.search

logger.info "Found: #{managers.count}"

format = '%-20s %-10s %s'
puts format % ['Name', 'Type', 'Date added']
puts '-' * 80
managers.each do |manager|
  puts format % [manager.name, manager.type, manager.date_added]
end



logger.info 'Pulling automate manager'
automate = AutomateApi::Models::NodeManager.automate

puts automate.to_yaml
