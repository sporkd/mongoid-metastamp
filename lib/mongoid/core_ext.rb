# encoding: utf-8

module Mongoid #:nodoc
  module Fields #:nodoc:
    module Mappings #:nodoc:

      def for(klass, foreign_key = false)
        return Serializable::Object unless klass
        if foreign_key
          return "#{MODULE}::ForeignKeys::#{klass.to_s.demodulize}".constantize
        end
        begin
          modules = "#{MODULE}::|BSON::|ActiveSupport::"
          if match = klass.to_s.match(Regexp.new("^(#{ modules })?(\\w+)$"))
            "#{MODULE}::#{match[2]}".constantize
          else
            klass.to_s.constantize
          end
        rescue NameError
          klass
        end
      end

    end
  end
end
