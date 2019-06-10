module AutomateApi
  module Resource
    class Base
      attr_reader :attributes
      include AutomateApi::Resource::EndpointAddon

      def initialize(data = {}, persisted = false)
        @attributes = Attributes.new(data)
        @persisted = false

        persisted! if persisted
      end

      def create(options = {})
        supports!(:create)
        raise RequestError, "Model has already been persisted, unable to create" if persisted?

        _api_request(self.class.endpoint('create'), options)
      end

      def update(options = {})
        supports!(:update)
        raise RequestError, "Model hasn't been persisted yet, unable to update" unless persisted?

        _api_request(self.class.endpoint('update'), options)
      end

      def save(options = {})
        persisted? ? update(options) : create(options)
      end

      # Check to see if the instance has been marked as persited
      #
      # @return [Bool] returns true if the model has been persisted
      def persisted?
        @persisted
      end

      # Mark the instance as persisted to the remote data store
      #
      # @return [Bool] return the updated persisted state
      def persisted!
        @persisted = true
      end

      def _api_request(endpoint, options = {})
        response = self.class._api_request(endpoint, attributes, options)

        if response.respond_to?(:attributes)
          @attributes = response.attributes
          @persisted = true
        end

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
        # Base api request path not including the model api path
        #
        # @return [String]
        def base_resource_url
          "/api/#{api_version}"
        end

        # Specify the api version used for api queries
        #
        # @param version [String] default: nil
        # @return [String] api version used for requests, default: v0
        def api_version(version = nil)
          @api_version = version unless version.nil?
          @api_version || 'v0'
        end


        # Set a list of fields that should be used for direct attribute access
        #
        # @param fields [Array(String)] Array of field names to assign
        # @return [Array(String)] the array of field names
        def fields(*fields)
          @fields = fields unless fields.empty?
          @fields
        end

        ##
        # Add body data to the options, this method can be overridden to customize
        # the behavior for some endpoints.
        ##
        def add_body_data(endpoint, options, data)
          options[:body] = data.to_json
        end

        def _api_request(endpoint, data = {}, request_options = {})
          path = Mustache.render(endpoint.path, data)
          url = [base_resource_url, path].join('/')

          if !data.keys.empty? && [:post, :put].include?(endpoint.method.to_sym)
            add_body_data(endpoint, request_options, data)
          end

          response = AutomateApi.client.api_exec(endpoint.method, url, request_options)

          if response.collectable?(endpoint.collect)
            coerce response[endpoint.collect], endpoint.klass || self, true
          else
            coerce response, endpoint.klass || self, true
          end
        end

        def method_missing(name, *args)
          if supports?(name)
            _api_request(endpoint(name), *args)
          else
            super
          end
        end

        # Coerces returned data into the appropriate model
        #
        # @param data [Array/Hash] data from api request
        # @param klass [Type] klass that the data will be coerced into
        # @return [Object] the class instance that contains the data
        def coerce(data, klass, persisted = false)
          if data.is_a?(Array)
            data.map do |item|
              klass.initialize_or_find(item, persisted)
            end
          else
            klass.initialize_or_find(data, persisted)
          end
        end

        # Initialize or find an instance of the model base on the passed in data
        # If the data is a Hash then it's directly converted into a model instance
        # Otherwise if it's a string it defaults to trying to call `fetch(id: data)`
        #
        # Override this method to customize this behavior in models
        #
        # @param data [Hash/String] Hash of data or a String used to fetch the model data
        # @return [Object] an instance of the model
        def initialize_or_find(data, persisted = false)
          if data.is_a?(Hash)
            self.new(data, persisted)
          else
            self.fetch(id: data)
          end
        end
      end
    end
  end
end
