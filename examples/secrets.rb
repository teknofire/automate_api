require 'automate_api'
require 'securerandom'

AutomateApi::Config.debug = true
logger = AutomateApi.logger

logger.info 'Fetching secrets'
secrets = AutomateApi::Models::Secret.search

format = '%-20s %-10s %s'
puts format % ['Name', 'Type', 'Last updated']
puts '-' * 80
secrets.each do |secret|
  puts format % [secret.name, secret.type, secret.last_modified]
end

passwd = SecureRandom.hex(10)

newitem = AutomateApi::Models::Secret.create(
            name: 'TestCreate',
            type: 'ssh',
            data: [
              { key: 'username', value: 'ubuntu' },
              { key: 'password', value: passwd }
            ]
          )
puts newitem.inspect
