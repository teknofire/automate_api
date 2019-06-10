require 'httparty'

module AutomateApi
  class Client
    include HTTParty
    include AutomateApi::Output

    base_uri AutomateApi::Config.automate_url

    def logger
      AutomateApi.logger
    end

    def reload
      base_uri(AutomateApi::Config.automate_url)
    end

    def base_uri(uri = nil)
      self.class.base_uri(uri)
    end

    def api_exec(method, path, options = {})
      opts = request_options(options)
      request = self.class.send(method.to_sym, path, opts)

      logger.debug <<~EOF
        API Request:
          Url: #{self.class.base_uri}
          Path: #{path}
          Method: #{method}
          Options: #{opts.inspect}
        API Response:
          Status: #{request.code} #{request.message}
          Data: #{request.parsed_response}
      EOF

      data = if request.parsed_response.is_a?(Array)
        request.parsed_response.map do |item|
          Hashie::Mash.new(item)
        end
      else
        Hashie::Mash.new(request.parsed_response)
      end

      if request.success?
        data
      else
        raise ResponseError.new(request, method, data.error)
      end
    end

    def default_request_options
      {
        verify: AutomateApi::Config.ssl_verify,
        headers: {
          "api-token" => AutomateApi::Config.auth_token,
          "content-type" => "application/json"
        }
      }
    end

    def request_options(options = {})
      opts = Hashie::Mash.new(options)
      default_request_options.merge(opts.to_hash(symbolize_keys: true))
    end
  end
end
