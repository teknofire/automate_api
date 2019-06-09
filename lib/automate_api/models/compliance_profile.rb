module AutomateApi
  module Models
    class ComplianceProfile < AutomateApi::Resource::Base
      fields :id, :name, :title, :maintainer, :copyright, :copyright_email, :license,
             :summary, :version, :owner, :supports, :depends, :sha256, :groups

      endpoints search: { path: 'compliance/profiles/search', method: :post, collect: :profiles },
                fetch: { path: '/compliance/profiles/read/{{owner}}/{{name}}/version/{{version}}' }
    end
  end
end
