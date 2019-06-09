module AutomateApi
  module Resource
    class Endpoint < Hashie::Dash
      property :path
      property :collect
      property :method, default: :get
      property :klass, default: nil

      def body?
        [:post, :put].include?(method)
      end
    end
  end
end
