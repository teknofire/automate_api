require 'automate_api'

# auto-load config
AutomateApi.load_config

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

begin
  team = AutomateApi::Models::Team.create(name: 'test-team', description: "testing teams")
rescue => e
  AutomateApi.logger.error e.message
end

teams = AutomateApi::Models::Team.all
teams.each do |team|
  logger.info team.name
  logger.info team.users.inspect

  next if team.name == 'admins'

  logger.info "Deleting #{team.name}"
  team.destroy
end
