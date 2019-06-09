module AutomateApi
  module Models
    class TeamUsers
      def self.initialize_or_find(user_id)
        User.all.select { |u| u.id == user_id }.first
      end
    end

    class Team < AutomateApi::Resource::Base
      fields :id, :name, :username, :email, :password
      endpoints all: { path: 'auth/teams', collect: 'teams' },
                fetch: { path: 'auth/teams/{{id}}' },
                create: { path: 'auth/teams', collect: 'team', method: 'post' },
                destroy: { path: 'auth/teams/{{id}}', collect: 'team', method: 'delete' },
                update: { path: 'auth/teams/{{id}}', collect: 'team', method: 'put' },
                users: { path: 'auth/teams/{{id}}/users', collect: 'user_ids', method: 'get', klass: TeamUsers }
    end
  end
end
