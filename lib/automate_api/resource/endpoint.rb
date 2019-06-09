module AutomateApi
  module Resource
    class Endpoint < Hashie::Dash
      property :path
      property :collect
      property :method, default: :get
      property :klass, default: nil
      property :alias, default: nil
    end

    class EndpointNotSupported < StandardError
      def initialize(endpoint, klass)
        super "Undefined api endpoint '#{endpoint}' for #{klass}.endpoints"
      end
    end

    class EndpointCollection < Hashie::Mash
      disable_warnings
    end

    module EndpointAddon
      def self.included(base)
        base.extend ClassMethods
      end

      def supports?(name)
        self.class.supports?(name)
      end

      def supports!(name)
        raise EndpointNotSupported.new(name, self.class) unless supports?(name)
      end

      module ClassMethods
        def supports?(name)
          !endpoint(name).nil?
        end

        def endpoint(name)
          endpoints[name] || endpoint_alias(name)
        end

        def endpoint_alias(name)
          ep = endpoints.select { |k,ep| ep.alias == name }.first
          ep.last unless ep.nil?
        end

        def endpoints(args = nil)
          @endpoints ||= EndpointCollection.new

          args.each_pair do |name, config|
            @endpoints[name] = Endpoint.new(config)
          end unless args.nil?

          @endpoints
        end
      end
    end
  end
end
