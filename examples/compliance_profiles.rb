require 'automate_api'
# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# Available search options
# {
#   "filters": [
#     {
#       "values": [
#         "string"
#       ],
#       "type": "string"
#     }
#   ],
#   "order": "ASC",
#   "sort": "string",
#   "page": 0,
#   "per_page": 0,
#   "owner": "string",
#   "name": "string",
#   "version": "string"
# }

# Fetch all profiles
#profiles = AutomateApi::Models::ComplianceProfile.search()

# Fetch profiles owned by the admin user
profiles = AutomateApi::Models::ComplianceProfile.search({ owner: 'admin' })

logger.info "Found #{profiles.count} profiles"

data = profiles.map do |profile|
  ["#{profile.owner.strip || 'unknown'}/#{profile.name}", profile.version]
end

format = "%-#{data.map{ |i| i.first.length }.max}s   %-10s"

puts format % ['Name', 'Version']
puts '-' * 100
data.each do |item|
  puts format % item
end

# figure out an example profile to access
p = profiles.first

profile = AutomateApi::Models::ComplianceProfile.fetch(owner: p.owner, name: p.name, version: p.version)
logger.info <<-EOF
Profile information
-----------------------------
Title: #{profile.title}
Summary: #{profile.summary}
Copyright: #{profile.copyright}
SHA256: #{profile.sha256}
EOF
