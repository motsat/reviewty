require 'ruboty/reviewer_assign/parsers/base'

module Ruboty
  module ReviewerAssign
    module Parsers
      class Assign < Ruboty::ReviewerAssign::Parsers::Base
        def parse
          vars = message.body.squish.split " "
          # [0]はbot自身、[1]は対象ユーザー
          unless vars.size == 4 || vars.size == 3
            raise ParseError.new 'invalid vars size'
          end

          group, pull_request_url =
            case vars.size
            when 3
              return [nil, vars[2]]
            when 4
              return [vars[2], vars[3]]
            else
              raise
            end
          [group, pull_request_url]
        end
      end
    end
  end
end
