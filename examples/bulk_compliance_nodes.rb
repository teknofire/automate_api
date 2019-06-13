require 'automate_api'
require 'securerandom'

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

secret = AutomateApi::Models::Secret.create(
            name: 'TestCreate',
            type: 'ssh',
            data: [
              { key: 'username', value: 'ubuntu' },
              { key: 'password', value: SecureRandom.hex(10) }
            ]
          )

bulk_nodes = []

20.times do |i|
  bulk_nodes << {
    name: "testnode-#{i}", manager: 'automate',
    target_config: {
      hosts: ["testnode-#{i}"],
      backend: 'ssh', secrets: [secret.id],
      port: 22, sudo: true
    },
    tags: [{
      key: 'name',
      value: 'bag'
    },{
      key: 'test',
      value: 'box'
    }]
  }
end

logger.info "Creating #{bulk_nodes.length} nodes"
created = AutomateApi::Models::ComplianceNode.bulk_create(
  nodes: bulk_nodes
)
