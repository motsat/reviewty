# TODO 消す
Dotenv.load
require "./reviewer"
module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'
      require 'redis-objects'

      on(/assign/i, name: "assign", description: "review [group] [pull_request_url]")

			def assign(message)
        team, pull_request_url = AssignParser.new(message.body).parse
        team_member_of(team: team)
        request_pull_request_review(pull_request_id_by(url: pull_request_url))
				message.reply("<@#{message.original[:user]["id"]}> assigned!")
			end

      on(/useradd/i, name: "useradd", description: "useradd [slack_real_name or email] [github_account]")

			def useradd(message)
        slack_realname_or_email, github_account = UserAddParser.new(message.body).parse

        slack_member = slack_member_by(realname_or_email: slack_realname_or_email)
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

        slack_member = slack_member_by(realname_or_email: slack_realname_or_email)
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

      on(/chgrp/i, name: "chgrp", description: "lists")
			def chgrp(message)
			end

      private
      def team_github_acount_name_stores
        ["team_bd_github_acounts", "team_bd_github_acounts"]
      end

      def team_member_of(team:)
        # users = Redis::List.new('users', marshal: true)
        # # users.del
        # # users << { github_account: "motsat", slack_account: "motsat" , teams: [:mp]}
        # # users << { github_account: "mo10sa10", slack_account: "mo10sa10slack" , teams: [:bd]}
        # users.find { |user| user[:teams].include? team }
      end

      def pull_request_id_by(url:)
        url.split("/").last
      end

      def request_pull_request_review(pull_request_id)
        octokit = Octokit::Client.new(access_token: ENV["OCTOKIT_ACCESS_TOKEN"])
        octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY"], pull_request_id, reviewers: ["mo10sa10"])
      end

      def users_list
        @users_list ||= slack_client.users_list
      end

      def slack_member_by(realname_or_email: )
        users_list["members"].find do |member|
          member_realname_or_emails = 
            [member["profile"]["real_name"],
             member["profile"]["real_name_normalized"],
             member["profile"]["display_name"],
             member["profile"]["email"]
          ]
          member_realname_or_emails.include? realname_or_email
        end
      end

      def slack_client
        @slack_client ||= Slack::Client.new(token: ENV['SLACK_TOKEN'])
      end

      class Parser
        attr_reader :message
        def initialize(message)
          @message = message
        end
        def parse
          raise "abstruct method"
        end
      end

      class AssignParser < Parser
        def parse
          vars = message.squish.split " "
          group, pull_request_url = 
            case vars.size
            when 3
              return [nil, vars[2]]
            when 4
              return [vars[2], vars[3]]
            else
              raise
            end
        end
      end

      class ListsParser
        def parse
          raise NotImplementedError "No need for now"
        end
      end

      class UserAddParser
        def parse
          vars = message.squish.split " "
          [vars[2], vars[3]] # 1.slack_realname or email, 2.github_account
        end
      end

      class UserDelParser
        def parse
          vars = message_body.squish.split " "
          vars[2] # 1.slack_realname or email
        end
      end

      class ChgrpParser
        def parse
        end
      end
    end
	end
end
