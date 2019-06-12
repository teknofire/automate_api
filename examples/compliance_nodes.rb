require 'automate_api'
# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# logger.info 'Fetching nodes'
nodes = AutomateApi::Models::ComplianceNode.search(filters: [], page: 1, per_page: 100)

format = '%-20s %-20s %-10s %s'

puts format % ['Name', "Last Contact", "Manager", "Status"]
puts '-' * 80
nodes.each do |node|
  puts format % [node.name, node.last_contact, node.manager, node.status]
end

secret = AutomateApi::Models::Secret.search.first

logger.info "Creating a new node"
created = AutomateApi::Models::ComplianceNode.bulk_create(
  nodes: [{
    name: 'testbox', manager: 'automate',
    target_config: {
      hosts: ['testbox'],
      backend: 'ssh', secrets: [secret.id],
      port: 22, sudo: true
    }
  }]
)

created.each do |node|
  logger.info "Deleting node we just created"
  node.destroy
end
