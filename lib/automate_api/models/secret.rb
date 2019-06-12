module AutomateApi
  module Models
    class Secret < AutomateApi::Resource::Base
      fields :id, :name, :type, :last_modified, :tags, :data
      endpoints search: { path: 'secrets/search', collect: 'secrets', method: 'post' },
                fetch: { path: 'secrets/id/{{id}}' },
                create: { path: 'secrets', method: 'post' },
                destroy: { path: 'secrets/id/{{id}}', method: 'delete' },
                update: { path: 'secrets/id/{{id}}', method: 'put' }
    end
  end
end
