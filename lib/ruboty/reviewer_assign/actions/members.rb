module Ruboty
  module ReviewerAssign
    module Actions
      class Members < Ruboty::Actions::Base
        def call
          message.reply(members)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def members
          summarys =  
            Reviewer.all.map do |reviewer|
              slack_api = SlackAPI.new
              member = slack_api.find_member_by_id(reviewer.slack_member_id)
              "Slack @#{member["name"]}\n GitHub: #{reviewer.github_account}\n タグ: #{reviewer.tags.join "/"}\n 最終レビュー日時: #{reviewer.last_reviewed_at}" 
            end
          "レビュアー:family:↓↓\n\n" + summarys.join("\n\n")
        end
      end
    end
  end
end

