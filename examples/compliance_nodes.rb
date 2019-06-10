require 'automate_api'
# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# logger.info 'Fetching nodes'
nodes = AutomateApi::Models::ComplianceNode.search(filters: [{ name: 'manager_type', values: [""], exclude: true }], page: 1, per_page: 100)

format = '%-20s %-20s %s'

puts format % ['Name', "Last Contact", "Status"]
puts '-' * 80
nodes.each do |node|
  puts format % [node.name, node.last_contact, node.status]
end
