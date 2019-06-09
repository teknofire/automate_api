module AutomateApi
  module Models
    class User < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      endpoints all: { path: 'auth/users', collect: 'users' },
                fetch: { path: 'auth/users/{{username}}' },
                create: { path: 'auth/users', method: 'post' },
                destroy: { path: 'auth/users/{{username}}', collect: 'user', method: 'delete' },
                update: { path: 'auth/users/{{username}}', collect: 'user', method: 'put' }
    end
  end
end
