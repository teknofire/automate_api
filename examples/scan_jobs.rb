require 'automate_api'

# auto-load config
AutomateApi.load_config

# AutomateApi::Config.debug = true
logger = AutomateApi.logger

jobs = AutomateApi::Models::ScanJob.exec_jobs

format = '%-20s %-21s %-21s %-7s %-10s %s'
def print_job_info(job, format)
  puts format % [job.name, job.start_time, job.end_time, job.type, job.status, job.profiles]
end

puts format % ['Name', 'Start', 'End', 'Type', 'Status', 'Profiles']
puts '-' * 90
jobs.each do |job|
  # fetch the full attributes
  job.fetch
  print_job_info(job, format)
end

automate = AutomateApi::Models::NodeManager.automate
node = AutomateApi::Models::ComplianceNode.search(filters: [{ key: 'manager_type', values: ['automate']}]).first
admin_profiles = AutomateApi::Models::ComplianceProfile.owned_by('admin')
profile1 = admin_profiles.first
profile2 = admin_profiles.last

test_api_job = AutomateApi::Models::ScanJob.search({ filters: [{ key: 'name', values: ['api-test-job'] }]}).first

unless profile1.nil? || profile2.nil?

  if test_api_job.nil?
    logger.info "Creating new job with profile #{profile1.slug}"
    test_api_job = AutomateApi::Models::ScanJob.create(
      name: 'api-test-job',
      type: 'exec',
      nodes: [node.id],
      node_selectors: [{
        manager_id: automate.id,
        filters: [{
          key: 'name',
          values: [node.name],
          exclude: false
        }]
      }],
      profiles: [profile1.slug],
      recurrence: '',
      tags: []
    )
    logger.info 'New job settings'
  else
    logger.info 'Existing job settings'
  end

  print_job_info test_api_job.fetch(), format

  logger.info "Update profile to be #{profile2.slug}"
  test_api_job.profiles = [profile2.slug]
  test_api_job.update

  logger.info 'Job info with updated profile'
  print_job_info test_api_job.fetch(), format

  test_api_job.destroy()

end
