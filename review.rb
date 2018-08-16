# TODO 消す
Dotenv.load

module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'
      require 'redis-objects'

      on(/review/i, name: "review", description: "review [group] [pull_request_url]")

			def review(message)
        team, pull_request_url = parse_review_message(message.body)
        team_member_of(team: team)
        request_pull_request_review(pull_request_id_by(url: pull_request_url))
				message.reply("<@#{message.original[:user]["id"]}> assigned!")
			end

      on(/useradd/i, name: "useradd", description: "useradd [slack_real_name or email] [github_account]")

			def useradd(message)
        slack_realname_or_email, github_account = parse_useradd_message(message.body)

        slack_id = lack_id_by(realname_or_email: slack_realname_or_email)
        if slack_id
          message.reply("<@#{message.original[:user]["id"]}> found!")
        else
          message.reply("<@#{message.original[:user]["id"]}> not found!")
        end
			end

      private
      def team_github_acount_name_stores
        ["team_bd_github_acounts", "team_bd_github_acounts"]
      end

      def team_member_of(team:)
        users = Redis::List.new('users', marshal: true)
 
        # users.del
        # users << { github_account: "motsat", slack_account: "motsat" , teams: [:mp]}
        # users << { github_account: "mo10sa10", slack_account: "mo10sa10slack" , teams: [:bd]}

        users.find { |user| user[:teams].include? team }
      end

      def parse_review_message(message_body)
        vars = message_body.squish.split " "
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

      def parse_useradd_message(message_body)
        vars = message_body.squish.split " "
        [vars[2], vars[3]] # 1.slack_realname or email, 2.github_account
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

      def slack_id_by(realname_or_email: )
        users_list["members"].find do |member|
          member_realname_or_emails = 
            [member["profile"]["real_name"],
             member["profile"]["real_name_normalized"],
             member["profile"]["display_name"],
             member["profile"]["email"]
          ]
          member_realname_or_emails.include? real_name_normalized
        end
      end

      def slack_client
        @slack_client ||= Slack::Client.new(token: ENV['SLACK_TOKEN'])
      end
		end
	end
end
