require 'ruboty/reviewer_assign/parsers/add'

module Ruboty
  module ReviewerAssign
    module Actions
      class Add < Ruboty::Actions::Base
        def call
          message.reply(add)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def add
          slack_member_id, github_account = Ruboty::ReviewerAssign::Parsers::Add.new(message).parse
          reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
          if reviewer
            "<@#{message.original[:user]["id"]}> <@#{slack_member_id}> already added!"
          else
            Reviewer.add(slack_member_id: slack_member_id, github_account: github_account)
            "<@#{message.original[:user]["id"]}> <@#{slack_member_id}> reviewer added!"
          end
        end
      end
    end
  end
end

