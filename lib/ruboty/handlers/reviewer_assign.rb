require "ruboty/reviewer_assign/actions/add"
require "ruboty/reviewer_assign/actions/del"
require "ruboty/reviewer_assign/actions/tagging"
require "ruboty/reviewer_assign/actions/assign"
require "ruboty/reviewer_assign/actions/members"

module Ruboty
  module Handlers
    # An Ruboty Handler + Actions to hoge-hige
    class ReviewerAssign < Base
			on(/assign /i, name: "assign", description: "プルリクのレビューをアサインする 例) assign (tag) https://github.com/motsat/reviewer_support_bot/pull/4")
      on(/add /i, name: "add", description: "レビュアーを登録する 例) add @slack_account github_account")
      on(/del /i, name: "del", description: "レビュアーを削除する 例) del @slack_account")
      on(/members\z/i, name: "members", description: "レビュアー一覧 例) members")
      on(/tagging /i, name: "tagging", description: "レビュアーにタグを設定 例) tagging @slack_account tag1 tag2")

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
				Ruboty::ReviewerAssign::Actions::Members.new(message).call
      end

			def tagging(message)
				Ruboty::ReviewerAssign::Actions::Tagging.new(message).call
			end
    end
  end
end
