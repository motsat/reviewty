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
              "@#{member["name"]}\n github: #{reviewer.github_account}\n tags: #{reviewer.tags.join "/"}\n last_reviewed_at: #{reviewer.last_reviewed_at}" 
            end
          "登録済のレビュアー:family:↓↓\n\n" + summarys.join("\n\n")
        end
      end
    end
  end
end

