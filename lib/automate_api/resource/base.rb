module AutomateApi
  module Resource
    class Base
      attr_reader :attributes
      def initialize(data)
        @attributes = Hashie::Mash.new(data)
      end

      def create(options = {})
        raise EndpointNotSupported.new(:create, self.class) unless supports?(:create)
        _api_request(self.class.endpoints['create'], options)
      end

      def update(options = {})
        raise EndpointNotSupported.new(:update, self.class) unless supports?(:update)
        _api_request(self.class.endpoints['update'], options)
      end

      def _api_request(endpoint, options = {})
        options[:body] = attributes.to_json
        response = self.class._api_request(endpoint, attributes, options)

        @attributes = response.attributes
        self
      end

      def method_missing(name, *args)
        if supports?(name)
          options = args.extract_options!
          _api_request(self.class.endpoints[name], options)
        elsif attributes.respond_to?(name)
          attributes.send(name, *args)
        else
          super
        end
      end

      def supports?(endpoint)
        self.class.supports?(endpoint)
      end

      class << self
        def supports?(endpoint)
        endpoints.has_key?(endpoint)
        end

        def build(data)
          self.new(data)
        end

        def create(data)
          raise QueryNotSupported.new(:create, self) unless supports?(:create)
          self.new(data).create
        end

        def base_resource_url
          "/api/#{api_version}"
        end

        def api_version(version = nil)
          @api_version = version unless version.nil?
          @api_version || 'v0'
        end

        def fields(*fields)
          @fields = fields unless fields.empty?
          @fields
        end

        def endpoints(args = nil)
          @endpoints ||= Hashie::Mash.new

          args.each_pair do |name, config|
            @endpoints[name] = Endpoint.new(config)
          end unless args.nil?

          @endpoints
        end

        def _api_request(endpoint, data = {}, request_options = {})
          path = Mustache.render(endpoint.path, data)
          url = [base_resource_url, path].join('/')

          response = AutomateApi.client.api_exec(endpoint.method, url, request_options)

          if response.collectable?(endpoint.collect)
            coerce response[endpoint.collect], endpoint.klass || self
          else
            coerce response, endpoint.klass || self
          end
        end

        def method_missing(name, *args)
          if supports?(name)
            _api_request(endpoints[name], *args)
          else
            super
          end
        end

        def coerce(data, klass)
          if data.is_a?(Array)
            data.map do |item|
              klass.initialize_or_find(item)
            end
          else
            klass.initialize_or_find(data)
          end
        end

        def initialize_or_find(data)
          if data.is_a?(Hash)
            self.new(data)
          else
            self.fetch(id: data)
          end
        end
      end
    end
  end
end
