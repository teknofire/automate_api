require 'automate_api'
require 'securerandom'

AutomateApi::Config.debug = true

puts users = AutomateApi::Resource::User.all
puts admin = AutomateApi::Resource::User.fetch(username: 'admin')
# data = Hashie::Mash.new()
puts newuser = AutomateApi::Resource::User.create(name: 'New user', username: "testtest#{rand(100)}", password: SecureRandom.hex(10))
puts "Update user"
newuser.name = 'Updated user'
newuser.update
puts "Fetch updated user"
testuser = AutomateApi::Resource::User.fetch(username: newuser.username)
puts "Updated user: #{testuser.username} - #{testuser.name}"
newuser.destroy
