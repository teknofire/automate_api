##
# Search filters
# {
#   "id": "string",
#   "type": "string",
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
#   "per_page": 0
# }
##
module AutomateApi
  module Models
    class ComplianceReport < AutomateApi::Resource::Base
      fields :id, :node_id, :node_name, :end_time, :status, :controls, :environment,
             :version, :platform, :statistics, :profiles, :job_id, :ipaddress, :fqdn

      endpoints all: { path: '/compliance/reporting/reports', collect: 'reports', method: 'post' },
                fetch: { path: '/compliance/reporting/reports/id/{{id}}', method: 'post' }
    end
  end
end
