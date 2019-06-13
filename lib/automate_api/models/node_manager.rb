module AutomateApi
  module Models
    class NodeManager < AutomateApi::Resource::Base
      fields :id, :name, :type, :credentials_id, :instance_credentials, :status,
             :account_id, :date_added, :credential_data
      endpoints search: { path: 'nodemanagers/search', collect: 'managers', method: 'post' },
                fetch: { path: 'nodemanagers/id/{{id}}' },
                create: { path: 'nodemanagers', method: 'post' },
                destroy: { path: 'nodemanagers/id/{{id}}', method: 'delete' },
                update: { path: 'nodemanagers/id/{{id}}', collect: 'managers', method: 'put' },
                rerun: { path: 'nodemanagers/rerun/id/{{id}}', collect: 'managers', method: 'post' }

      def self.automate
        search(filters: [{ key: 'type', value: 'automate' }]).first
      end
    end
  end
end
