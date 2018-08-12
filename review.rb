# TODO 消す
Dotenv.load
module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'

      on(/review/i, name: "review", description: "assign review")

			def review(message)
        vars = message.body.squish.split " "

        group, pull_request_url = 
          case vars.size
          when 3
            [nil, vars[2]]
          when 4
            [vars[2], vars[3]]
          else
            return
          end

        pull_request_id = pull_request_url.split("/").last
        octokit = Octokit::Client.new
        octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY"], pull_request_url, reviewers: ["mo10sa10"])

				message.reply("Hello!!")
			end
		end
	end
end

