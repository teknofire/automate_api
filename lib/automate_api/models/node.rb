module AutomateApi
  module Models
    class Node < AutomateApi::Resource::Base
      fields :id, :name, :checkin, :chef_tags, :chef_version, :environment,
             :fqdn, :has_runs_data, :last_ccr_received, :latest_run_id, :organization,
             :platform, :platform_family, :platform_version, :policy_group, :policy_name,
             :policy_revision, :source_fqdn, :uptime_seconds, :run_list

      endpoints all: { path: 'cfgmgmt/nodes' }

      def runs
        NodeRun.all(node_id: id)
      end

      def run(run_id)
        NodeRun.fetch(node_id: id, id: run_id)
      end
    end
  end
end
