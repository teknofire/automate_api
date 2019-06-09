module AutomateApi
  module Resource
    class Base
      attr_reader :attributes
      include AutomateApi::Resource::EndpointAddon

      def initialize(data)
        @attributes = Attributes.new(data)
      end

      def create(options = {})
        supports!(:create)
        _api_request(self.class.endpoint('create'), options)
      end

      def update(options = {})
        supports!(:update)
        _api_request(self.class.endpoint('update'), options)
      end

      def _api_request(endpoint, options = {})
        response = self.class._api_request(endpoint, attributes, options)

        @attributes = response.attributes if response.respond_to?(:attributes)

        response
      end

      def method_missing(name, *args)
        if supports?(name)
          options = args.extract_options!
          _api_request(self.class.endpoint(name), options)
        elsif attributes.respond_to?(name)
          attributes.send(name, *args)
        else
          super
        end
      end

      class << self
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

        def _api_request(endpoint, data = {}, request_options = {})
          path = Mustache.render(endpoint.path, data)
          url = [base_resource_url, path].join('/')

          if !data.keys.empty? && [:post, :put].include?(endpoint.method.to_sym)
            request_options[:body] = data.to_json
          end

          response = AutomateApi.client.api_exec(endpoint.method, url, request_options)

          if response.collectable?(endpoint.collect)
            coerce response[endpoint.collect], endpoint.klass || self
          else
            coerce response, endpoint.klass || self
          end
        end

        def method_missing(name, *args)
          if supports?(name)
            _api_request(endpoint(name), *args)
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
