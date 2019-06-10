module AutomateApi
  module Models
    # Node model
    #
    # Endpoints:
    # * search - search for nodes
    #   Available search options
    #   {
    #     "filters": [
    #       {
    #         "key": "string",
    #         "exclude": true,
    #         "values": [
    #           "string"
    #         ]
    #       }
    #     ],
    #     "order": "ASC",
    #     "sort": "string",
    #     "page": 0,
    #     "per_page": 0
    #   }
    class ComplianceNode < AutomateApi::Resource::Base
      fields :id, :name, :platform, :platform_version, :manager, :tags, :last_contact,
             :status, :last_job, :target_config, :connection_error, :state, :projects

      endpoints search: { path: 'nodes/search', collect: 'nodes', method: 'post' },
                fetch: { path: 'nodes/id/{{id}}' },
                create: { path: 'nodes', method: 'post' },
                destroy: { path: 'nodes/id/{{id}}', method: 'delete' },
                update: { path: 'nodes/id/{{id}}', method: 'put' }
    end
  end
end
