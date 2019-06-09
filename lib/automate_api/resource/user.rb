module AutomateApi
  module Resource
    class User < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      queries all: { path: 'users', collect: 'users' },
              fetch: { path: 'users/{{username}}' },
              create: { path: 'users', method: 'post' },
              destroy: { path: 'users/{{username}}', collect: 'user', method: 'delete' },
              update: { path: 'users/{{username}}', collect: 'user', method: 'put' }
    end
  end
end
