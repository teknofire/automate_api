module AutomateApi
  module Resource
    class TeamUsers
      def self.initialize_or_find(user_id)
        User.all.select { |u| u.id == user_id }.first
      end
    end

    class Team < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      endpoints all: { path: 'auth/teams', collect: 'teams' },
                fetch: { path: 'auth/teams/{{username}}' },
                create: { path: 'auth/teams', method: 'post' },
                destroy: { path: 'auth/teams/{{id}}', collect: 'user', method: 'delete' },
                update: { path: 'auth/teams/{{id}}', collect: 'user', method: 'put' },
                users: { path: 'auth/teams/{{id}}/users', collect: 'user_ids', method: 'get', klass: AutomateApi::Resource::TeamUsers }
    end
  end
end
