require 'automate_api'

# auto-load config
AutomateApi.load_config

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

# logger.info 'Fetching nodes'
nodes = AutomateApi::Models::Node.all

# format = '%-20s %-8s %-21s %s'
# puts nodes.first.attributes.inspect
# puts format % ['Name', "Status", "Checkin", "Environment"]

nodes.each do |node|
  puts <<~EOF
==========================================
Node: #{node.name}
==========================================
         FQDN: #{"node.fqdn"}
  Environment: #{node.environment}
       Status: #{node.status}
 Last checkin: #{node.checkin}
  EOF

  runs = node.runs
  next if runs.empty?

  puts "" #intentional blank line
  puts "Latest runs"
  puts '-' * 80
  format = '%-8s %-21s %-21s'

  puts format % ['Status', 'Start', 'End']
  puts '-' * 80
  runs.sort_by { |r| r.start_time }.reverse.each do |run|
    puts format % [run.status, run.start_time, run.end_time]
  end
  puts "" #intential
end
