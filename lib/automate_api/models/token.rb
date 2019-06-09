module AutomateApi
  module Models
    class Token < AutomateApi::Resource::Base
      fields :id, :description, :active, :value
      endpoints all: { path: 'auth/tokens', collect: 'tokens' },
                fetch: { path: 'auth/tokens/{{id}}' },
                create: { path: 'auth/tokens', method: 'post' },
                destroy: { path: 'auth/tokens/{{id}}', collect: 'token', method: 'delete' },
                update: { path: 'auth/tokens/{{id}}', collect: 'token', method: 'put' }
    end
  end
end
