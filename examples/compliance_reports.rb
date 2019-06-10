require 'automate_api'
require 'yaml'

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# logger.info 'Fetching nodes'
reports = AutomateApi::Models::ComplianceReport.all

# format = '%-20s %-8s %-21s %s'
# puts nodes.first.attributes.inspect
# puts format % ['Name', "Status", "Checkin", "Environment"]

reports.each do |report|
  puts <<~EOF
==========================================
Report for: #{report.node_name}
==========================================
  Report ID: #{report.id}
   End date: #{report.end_time}
     Status: #{report.status}
   Controls: #{report.controls.to_hash.to_yaml.gsub("\n", "\n     ")}
  EOF
end
