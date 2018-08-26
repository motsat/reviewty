require "ruboty/reviewer_assign/actions/add"
require "ruboty/reviewer_assign/actions/del"
require "ruboty/reviewer_assign/actions/tagging"
require "ruboty/reviewer_assign/actions/assign"
require "ruboty/reviewer_assign/actions/members"

module Ruboty
  module Handlers
    # An Ruboty Handler + Actions to hoge-hige
    class ReviewerAssign < Base
			on(/assign/i, name: "assign", description: "review [tag] [pull_request_url]")
      on(/add/i, name: "add", description: "add [slack_real_name or email] [github_account]")
      on(/del/i, name: "del", description: "del [slack_real_name or email]")
      on(/members/i, name: "members", description: "reviewers")
      on(/tagging/i, name: "tagging", description: "chtags [slack_real_name or email] [tags]...")

      # env :DEFAULT_HOGE_TEXT1, "DEFAULT_HOGE_TEXT1 desc"
      # env :DEFAULT_HOGE_TEXT2, "DEFAULT_HOGE_TEXT2 desc"

      def assign(message)
        Ruboty::ReviewerAssign::Actions::Assign.new(message).call
      end

      def add(message)
				Ruboty::ReviewerAssign::Actions::Add.new(message).call
			end

			def del(message)
				Ruboty::ReviewerAssign::Actions::Del.new(message).call
			end

			def members(message)
        p 222
				Ruboty::ReviewerAssign::Actions::Members.new(message).call
      end

			def tagging(message)
				Ruboty::ReviewerAssign::Actions::Tagging.new(message).call
			end
    end
  end
end
