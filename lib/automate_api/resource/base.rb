module AutomateApi
  module Resource
    class Query < Hashie::Dash
      # property :all
      # property :fetch
      property :path
      property :collect
      property :method, default: :get
      property :klass, default: nil

      def body?
        [:post, :put].include?(method)
      end
    end

    class Base
      attr_reader :attributes
      def initialize(data)
        @attributes = Hashie::Mash.new(data)
      end

      def create(options = {})
        raise QueryNotSupported.new(:create, self.class) unless supports?(:create)

        options[:body] = attributes.to_json
        response = self.class._api_request(self.class.queries['create'], attributes, options)
        @attributes = response.attributes
        self
      end

      def update(options = {})
        raise QueryNotSupported.new(:update, self.class) unless supports?(:update)

        options[:body] = attributes.to_json

        response = self.class._api_request(self.class.queries['update'], attributes, options)

        @attributes = response.attributes
        self
      end

      def method_missing(name, *args)
        if supports?(name)
          options = args.extract_options!
          options[:body] = attributes.to_json
          self.class._api_request(self.class.queries[name], attributes, options)
        elsif attributes.respond_to?(name)
          attributes.send(name, *args)
        else
          super
        end
      end

      def supports?(query)
        self.class.supports?(query)
      end

      class << self
        def supports?(query)
          queries.has_key?(query)
        end

        def build(data)
          self.new(data)
        end

        def create(data)
          raise QueryNotSupported.new(:create, self) unless supports?(:create)
          self.new(data).create
        end

        def base_resource_url
          "/api/v0/auth"
        end

        def fields(*fields)
          @fields = fields unless fields.empty?
          @fields
        end

        def queries(args = nil)
          @queries ||= Hashie::Mash.new

          args.each_pair do |name, config|
            @queries[name] = Query.new(config)
          end unless args.nil?

          @queries
        end

        def _api_request(query, data = {}, request_options = {})
          path = Mustache.render(query.path, data)
          url = [base_resource_url, path].join('/')

          response = AutomateApi.client.api_exec(query.method, url, request_options)

          if response.collectable?(query.collect)
            coerce response[query.collect], query.klass || self
          else
            coerce response, query.klass || self
          end
        end

        def method_missing(name, *args)
          if supports?(name)
            _api_request(queries[name], *args)
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
