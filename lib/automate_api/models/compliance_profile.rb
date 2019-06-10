##
# ComplianceProfiles
#
# Endpoints:
# * search - returns a list of compliance profiles based on the provided filters
#     Available search filters
#     {
#       "filters": [
#         {
#           "values": [
#             "string"
#           ],
#           "type": "string"
#         }
#       ],
#       "order": "ASC",
#       "sort": "string",
#       "page": 0,
#       "per_page": 0,
#       "owner": "string",
#       "name": "string",
#       "version": "string"
#     }
#   TODO: Figure out a method to document and handle this, probably use the swagger
# * fetch - Will fetch a single compliance profile based owner, name and version provided.
# * delete - Delete the profile from Automate based on owner, name and version
##
module AutomateApi
  module Models
    class ComplianceProfile < AutomateApi::Resource::Base
      fields :id, :name, :title, :maintainer, :copyright, :copyright_email, :license,
             :summary, :version, :owner, :supports, :depends, :sha256, :groups

      endpoints search: { path: 'compliance/profiles/search', method: :post, collect: :profiles },
                fetch: { path: '/compliance/profiles/read/{{owner}}/{{name}}/version/{{version}}' },
                delete: { path: '/compliance/profiles/{{owner}}/{{name}}/version/{{version}}', method: :delete }
    end
  end
end
