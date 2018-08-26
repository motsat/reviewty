require 'ruboty/reviewer_assign/parsers/add'

module Ruboty
  module ReviewerAssign
    module Actions
      class Add < Ruboty::Actions::Base
        def call
          message.reply(add)
        rescue => e
          message.reply(e.message)
        end

        private
        def add
          slack_member_id, github_account = Ruboty::ReviewerAssign::Parsers::Add.new(message).parse
          reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
          if reviewer
            message.reply("<@#{message.original[:user]["id"]}> <@#{slack_member_id}> already exists!")
          else
            Reviewer.add(slack_member_id: slack_member["id"], github_account: github_account)
            message.reply("<@#{message.original[:user]["id"]}> <@#{slack_member["id"]}> reviewer added!")
          end
        end
      end
    end
  end
end

