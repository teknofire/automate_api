module AutomateApi
  module Models
    class ComplianceStats < AutomateApi::Resource::Base
      fields :controls_summary, :node_summary, :report_summary

      endpoints summary: { path: '/compliance/reporting/stats/summary', method: 'post' }
    end
  end
end
