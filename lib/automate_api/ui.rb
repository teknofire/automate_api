module AutomateApi
  module Output
    def self.included(base)
      base.extend ClassMethods
    end

    def info(*args)
      self.class.info(*args)
    end

    def debug(*args)
      self.class.debug(*args)
    end

    def error(*args)
      self.class.error(*args)
    end

    module ClassMethods
      def info(*msg)
        display 'info', *msg
      end

      def warn(*msg)
        display 'warn', *msg
      end

      def debug(*msg)
        return unless AutomateApi::Config.debug
        display 'debug', *msg
      end

      def error(*msg)
        display 'error', *msg
      end

      def display(type, *msg)
        puts "[#{type.upcase}] #{msg.join("\n")}"
      end
    end
  end
end
