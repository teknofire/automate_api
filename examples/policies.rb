require 'automate_api'
# AutomateApi::Config.debug = true
logger = AutomateApi.logger

logger.info 'Fetching policies'
policies = AutomateApi::Models::IamV1Policy.all

logger.info "Found: #{policies.count}"

policies.each do |policy|
  puts policy.inspect
end
