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

        reviewers = tag ?  Reviewer.by_tag(tag) : Reviewer.all

        # assignしようとしている人がReviewer登録しているとも限らない
        reviewers.reject! {|r| r.slack_member_id == message.original[:user]["id"] }

        return message.reply("<@#{message.original[:user]["id"]}> member not found") if reviewers.size == 0
        # TODO pick size
        reviewers = reviewers.sort(&:last_reviewed_at).first 1
        github_api.assign_reviewer(pull_request_url, reviewers.map(&:github_account))
        to = reviewers.map { |l| "<@#{l.slack_member_id}>" }.join " "
        reviewers.each do |l| 
          l.last_reviewed_at = Time.now
          l.save!
        end
				message.reply("please review #{pull_request_url}\n#{to}")
			end

      on(/add/i, name: "add", description: "add [slack_real_name or email] [github_account]")

			def add(message)
        slack_realname_or_email, github_account = UserAddParser.new(message.body).parse

        slack_member = slack_api.find_member_by_realname_or_email(slack_realname_or_email)
        unless slack_member
          message.reply("<@#{message.original[:user]["id"]}> not found in slack members!")
          return
        end

        Reviewer.add(slack_member_id: slack_member["id"], github_account: github_account)
        message.reply("<@#{message.original[:user]["id"]}> <@#{slack_member["id"]}> reviewer added!")
			end

      on(/del/i, name: "del", description: "del [slack_real_name or email]")

			def del(message)
        slack_realname_or_email = UserDelParser.new(message.body).parse

        slack_member = slack_api.find_by_realname_or_email(slack_realname_or_email)
        if slack_member
          Reviewer.delete(slack_member_id: slack_member["id"])
          message.reply("<@#{message.original[:user]["id"]}> modified success!")
        else
          message.reply("<@#{message.original[:user]["id"]}> not found in slack members!")
        end
			end

      on(/members/i, name: "members", description: "reviewers")

			def members(message)
        summarys =  
          Reviewer.all.map do |reviewer|
          binding.pry
            member = slack_api.find_member_by_id(reviewer.slack_member_id)
            "@#{member["real_name"]}\n github: #{reviewer.github_account}\n tags: #{reviewer.tags.join "/"}\n last_reviewed_at: #{reviewer.last_reviewed_at}" 
          end
        message.reply "reviewers↓↓\n\n" + summarys.join("\n\n")
			end

      on(/tagging/i, name: "tagging", description: "chtags [slack_real_name or email] [tags]...")
			def tagging(message)
        slack_realname_or_email, tags = ChTagsParser.new(message.body).parse
        slack_member = slack_api.find_member_by_realname_or_email(slack_realname_or_email)
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
