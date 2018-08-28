module Ruboty
  module ReviewerAssign
    module Actions
      class Tagging < Ruboty::Actions::Base
        def call
          message.reply(tagging)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def tagging
          slack_name, tags = Ruboty::ReviewerAssign::Parsers::Tagging.new(message).parse
          slack_member = slack_api.find_member_by_name(slacK_name)
          unless slack_member
            return "<@#{message.original[:user]["id"]}> slack_member not found"
          end
          reviewer = Reviewer.find_by_slack_member_id(slack_member["id"])
          reviewer.tags = tags
          reviewer.save!
          "<@#{message.original[:user]["id"]}> modified success!"
        end
      end
    end
  end
end
