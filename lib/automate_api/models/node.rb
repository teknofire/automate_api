module AutomateApi
  module Models
    class Note < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      endpoints all: { path: 'node', collect: 'users' },
                fetch: { path: 'node/id/{{id}}' },
                create: { path: 'auth/users', method: 'post' },
                destroy: { path: 'auth/users/{{username}}', collect: 'user', method: 'delete' },
                update: { path: 'auth/users/{{username}}', collect: 'user', method: 'put' }
    end
  end
end
