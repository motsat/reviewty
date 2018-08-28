module Ruboty
  module ReviewerAssign
    module Actions
      class Del < Ruboty::Actions::Base
        def call
          message.reply(del)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def del
          slack_member_id = Ruboty::ReviewerAssign::Parsers::Del.new(message).parse
          reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
          if reviewer
            Reviewer.delete(slack_member_id: slack_member_id)
            "<@#{message.original[:user]["id"]}> modified success!"
          else
            "<@#{message.original[:user]["id"]}> not found in slack members!"
          end
        end
      end
    end
  end
end
