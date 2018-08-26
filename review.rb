# TODO 消す
Dotenv.load
require "./reviewer"
require "./parser"
require "./slack_api"
require "./github_api"

module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'
      require 'redis-objects'

      on(/assign/i, name: "assign", description: "review [tag] [pull_request_url]")

			def assign(message)
			end

      on(/add/i, name: "add", description: "add [slack_real_name or email] [github_account]")

			def add(message)
        slack_member_id, github_account = UserAddParser.new(message).parse
        reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
        if reviewer
          message.reply("<@#{message.original[:user]["id"]}> <@#{slack_member_id}> already exists!")
        else
          Reviewer.add(slack_member_id: slack_member["id"], github_account: github_account)
          message.reply("<@#{message.original[:user]["id"]}> <@#{slack_member["id"]}> reviewer added!")
        end
			end

      on(/del/i, name: "del", description: "del [slack_real_name or email]")

			def del(message)
        slack_member_id = UserDelParser.new(message).parse
        reviewer = Reviewer.find_by_slack_member_id(slack_member_id)
        if reviewer
          Reviewer.delete(slack_member_id: slack_member_id)
          message.reply("<@#{message.original[:user]["id"]}> modified success!")
        else
          message.reply("<@#{message.original[:user]["id"]}> not found in slack members!")
        end
			end

      on(/members/i, name: "members", description: "reviewers")

			def members(message)
        summarys =  
          Reviewer.all.map do |reviewer|
            member = slack_api.find_member_by_id(reviewer.slack_member_id)
            "@#{member["name"]}\n github: #{reviewer.github_account}\n tags: #{reviewer.tags.join "/"}\n last_reviewed_at: #{reviewer.last_reviewed_at}" 
          end
        message.reply "reviewers↓↓\n\n" + summarys.join("\n\n")
			end

      on(/tagging/i, name: "tagging", description: "chtags [slack_real_name or email] [tags]...")
			def tagging(message)
        slack_name, tags = ChTagsParser.new(message).parse
        slack_member = slack_api.find_member_by_name(slacK_name)
        unless slack_member
          message.reply("<@#{message.original[:user]["id"]}> slack_member not found")
          return 
        end
        reviewer = Reviewer.find_by_slack_member_id(slack_member["id"])
        reviewer.tags = tags
        reviewer.save!
        message.reply("<@#{message.original[:user]["id"]}> modified success!")
			end

      private

      def github_api
        @github_api ||= GithubAPI.new
      end

      def slack_api
        @slack_api ||= SlackAPI.new
      end
    end
  end
end
