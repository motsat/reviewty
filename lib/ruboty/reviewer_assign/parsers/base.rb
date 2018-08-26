require 'active_support/core_ext/string/filters'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Base
        attr_reader :message
        def initialize(message)
          @message = message
        end
        def parse
          raise "abstruct method"
        end
      end
    end
  end
end
