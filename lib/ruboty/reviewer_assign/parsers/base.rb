require 'active_support/core_ext/string/filters'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Base
        class ParseError < StandardError; end
        attr_reader :message
        def initialize(message)
          @message = message
        end
        def parse
          raise "abstruct method"
        end

        def raise_parse_error(message)
          raise ParseError.new message
        end
      end
    end
  end
end
