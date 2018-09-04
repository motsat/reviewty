require 'ruboty/reviewer_assign/parsers/tagging'

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
          slack_member_id, tags = Ruboty::ReviewerAssign::Parsers::Tagging.new(message).parse
          reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
          unless reviewer
            return "<@#{slack_member_id}> レビュアーが見つかりません:tired_face:"
          end
          reviewer.tags = tags
          reviewer.save!
          "<@#{slack_member_id}> タグを変更しました:muscle:"
        end

        def slack_api
          SlackAPI.new
        end
      end
    end
  end
end
