require 'ruboty/reviewer_assign/parsers/base'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Tagging < Ruboty::ReviewerAssign::Parsers::Base
        def parse
          vars = message.body.squish.split " "
          raise ParseError.new 'invalid vars size' unless vars.size > 1
          raise ParseError.new "invalid slack account : #{vars[2]}" unless message.original[:mention_to][1]
          slack_member_id =  message.original[:mention_to][1]["id"]
          [slack_member_id, vars[3..-1]] # 1.slack_realname or email, 2.tags
        end
      end
    end
  end
end
