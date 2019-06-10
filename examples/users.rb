require 'automate_api'
require 'securerandom'

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

users = AutomateApi::Models::User.all

format = "%-15s %s"
logger.info "User list"

puts format % ['Username', 'Name']
puts '-'*80
users.each do |user|
  puts format % [user.username, user.name]
end
# blank line added intentionally
puts ""

admin = AutomateApi::Models::User.fetch(username: 'admin')
newuser = AutomateApi::Models::User.create(name: 'New user', username: "testtest#{rand(100)}", password: SecureRandom.hex(10))

logger.info "Update user"
newuser.name = 'Updated user'
newuser.update

logger.info "Fetch updated user"
testuser = AutomateApi::Models::User.fetch(username: newuser.username)

logger.info "Updated user: #{testuser.username} - #{testuser.name}"
newuser.destroy

#clean up
AutomateApi::Models::User.all.each do |user|
  next unless user.username.match?(/testtest/)
  logger.info "Deleting #{user.username}"
  user.destroy
end
