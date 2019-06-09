require 'automate_api'
require 'securerandom'

AutomateApi::Config.debug = true

users = AutomateApi::Resource::User.all
admin = AutomateApi::Resource::User.fetch(username: 'admin')
# data = Hashie::Mash.new()
newuser = AutomateApi::Resource::User.create(name: 'New user', username: "testtest#{rand(100)}", password: SecureRandom.hex(10))
AutomateApi.logger.info "Update user"
newuser.name = 'Updated user'
newuser.update
AutomateApi.logger.info "Fetch updated user"
testuser = AutomateApi::Resource::User.fetch(username: newuser.username)
AutomateApi.logger.info "Updated user: #{testuser.username} - #{testuser.name}"
newuser.destroy

begin
team = AutomateApi::Resource::Team.create(name: 'test-team', description: "testing teams")
rescue => e
  AutomateApi.logger.error e.message
end
teams = AutomateApi::Resource::Team.all
teams.each do |team|
  puts team.name
  AutomateApi.logger.info team.users.inspect
  next if team.name == 'admins'
  AutomateApi.logger.info "Deleting #{team.name}"
  team.destroy
end
