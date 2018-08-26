require 'ruboty/reviewer_assign/parsers/base'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Add < Ruboty::ReviewerAssign::Parsers::Base
        def parse
          vars = message.body.squish.split " "
          # [0]はbot自身、[1]は対象ユーザー
          slack_member_id =  message.original[:mention_to][1]["id"]
          github_account = vars[3]
          [slack_member_id, github_account]
        end
      end
    end
  end
end
