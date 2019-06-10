module AutomateApi
  module Models
    class NodeRun < AutomateApi::Resource::Base
      fields :id, :node_id, :node_name

      endpoints all: { path: 'cfgmgmt/nodes/{{node_id}}/runs', collect: 'collection_fields' },
                fetch: { path: 'cfgmgmt/nodes/{{node_id}}/runs/{{id}}' }
    end
  end
end
