module AutomateApi
  module Resource
    class TeamUsers
      def self.initialize_or_find(user_id)
        User.all.select { |u| u.id == user_id }.first
      end
    end

    class Team < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      queries all: { path: 'teams', collect: 'teams' },
              fetch: { path: 'teams/{{username}}' },
              create: { path: 'teams', method: 'post' },
              destroy: { path: 'teams/{{id}}', collect: 'user', method: 'delete' },
              update: { path: 'teams/{{id}}', collect: 'user', method: 'put' },
              users: { path: 'teams/{{id}}/users', collect: 'user_ids', method: 'get', klass: AutomateApi::Resource::TeamUsers }
    end
  end
end
