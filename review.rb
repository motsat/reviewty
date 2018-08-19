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
        tag, pull_request_url = AssignParser.new(message.body).parse

        reviewers = 
          if tag
            Reviewer.by_tag(tag)
          else
            # TODO laters reviewed
            [Reviewer.all.first]
          end

        # assignしようとしている人がReviewer登録しているとも限らない
        reviewers.reject! {|r| r.slack_member_id == message.original[:user]["id"] }

        return message.reply("<@#{message.original[:user]["id"]}> member not found") if reviewers.size == 0

        github_api.assign_reviewer(pull_request_url)
				message.reply("<@#{message.original[:user]["id"]}> assigned!")
			end

      on(/useradd/i, name: "useradd", description: "useradd [slack_real_name or email] [github_account]")

			def useradd(message)
        slack_realname_or_email, github_account = UserAddParser.new(message.body).parse

        slack_member = slack_api.find_by_realname_or_email(slack_realname_or_email)
        unless slack_member
          message.reply("<@#{message.original[:user]["id"]}> not found in slack members!")
          return
        end

        Reviewer.add(slack_member_id: slack_member["id"], github_account: github_account)
        message.reply("<@#{message.original[:user]["id"]}> modified success!")
			end

      on(/userdel/i, name: "userdel", description: "userdel [slack_real_name or email]")

			def userdel(message)
        slack_realname_or_email = UserDelParser.new(message.body).parse

        slack_member = slack_api.find_by_realname_or_email(slack_realname_or_email)
        if slack_member
          Reviewer.delete(slack_member_id: slack_member["id"])
          message.reply("<@#{message.original[:user]["id"]}> modified success!")
        else
          message.reply("<@#{message.original[:user]["id"]}> not found in slack members!")
        end
			end

      on(/lists/i, name: "lists", description: "lists")

			def lists(message)
        message.reply "reviewers↓↓\n\n" + Reviewer.all.map(&:to_s).join("\n")
			end

      on(/chtags/i, name: "chtags", description: "chtags [slack_real_name or email] [tags]...")
			def chtags(message)
        slack_realname_or_email, tags = ChTagsParser.new(message.body).parse
        slack_member = slack_api.find_by_realname_or_email(slack_realname_or_email)
        unless slack_member
          message.reply("<@#{message.original[:user]["id"]}> slack_member not found")
          return 
        end
        reviewer = Reviewer.find_by_slack_member_id(slack_member["id"])
        reviewer.set_tags tags
        message.reply("<@#{message.original[:user]["id"]}> modified success!")
			end

      private
      def tag_member_of(tag:)
        # users = Redis::List.new('users', marshal: true)
        # # users.del
        # # users << { github_account: "motsat", slack_account: "motsat" , tags: [:mp]}
        # # users << { github_account: "mo10sa10", slack_account: "mo10sa10slack" , tags: [:bd]}
        # users.find { |user| user[:tags].include? tag }
      end

      def github_api
        @github_api ||= GithubAPI.new
      end

      def slack_api
        @slack_api ||= SlackAPI.new
      end
    end
  end
end
