module AutomateApi
  module Models
    class ScanJob < AutomateApi::Resource::Base
      fields :id, :name, :type, :timeout, :tags, :start_time, :end_time, :status,
             :retries, :retries_left, :results, :nodes, :profiles, :node_count,
             :node_selectors, :scheduled_time, :recurrence, :parent_id, :job_count,
             :deleted
      endpoints search: { path: 'compliance/scanner/jobs/search', collect: 'jobs', method: 'post' },
                fetch: { path: 'compliance/scanner/jobs/id/{{id}}' },
                create: { path: 'compliance/scanner/jobs', method: 'post' },
                destroy: { path: 'compliance/scanner/jobs/id/{{id}}', method: 'delete' },
                update: { path: 'compliance/scanner/jobs/id/{{id}}', collect: 'job', method: 'put' }

      def self.exec_jobs
        search(filters: [{ key: 'job_type', values: ['exec'] }])
      end
    end
  end
end
