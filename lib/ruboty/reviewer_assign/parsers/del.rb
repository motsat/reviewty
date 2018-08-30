require 'ruboty/reviewer_assign/parsers/base'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Del < Ruboty::ReviewerAssign::Parsers::Base
        def parse
          vars = message.body.squish.split " "
          raise ParseError.new 'invalid vars size' unless vars.size == 3
          raise ParseError.new "invalid slack account : #{vars[2]}" unless message.original[:mention_to][1]
          message.original[:mention_to][1]["id"]
        end
      end
    end
  end
end
