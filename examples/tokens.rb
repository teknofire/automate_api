require 'automate_api'
# AutomateApi::Config.debug = true
logger = AutomateApi.logger

logger.info 'Fetching tokens'
tokens = AutomateApi::Models::Token.all

logger.info "Found: #{tokens.count}"

token = AutomateApi::Models::Token.create(description: 'test token', active: true)
logger.info token.inspect
token.active = false
token.update
logger.info token.inspect
token.destroy
