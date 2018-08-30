require 'ruboty/reviewer_assign/parsers/base'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Add < Ruboty::ReviewerAssign::Parsers::Base
        def parse
          vars = message.body.squish.split " "
          # [0]はbot自身、[1]は対象ユーザー
          raise ParseError.new 'invalid vars size' unless vars.size == 4
          raise ParseError.new "invalid slack account : #{vars[2]}" unless message.original[:mention_to][1]
          slack_member_id =  message.original[:mention_to][1]["id"]
          github_account = vars[3]
          [slack_member_id, github_account]
        end
      end
    end
  end
end
