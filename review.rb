module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'

      on(/review/i, name: "review", description: "assign review")

			def review(message)
        vars.squish.split ","
        team, pull_request_url = 
          case vars.size
          when 2
            nil, vars[1]
          when 3
            vars[1], vars[2]
          when 3
          else
        end

        pull_request_id = pull_request_url.split("/").last
        octokit = Octokit::Client.new
        octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY", pull_request_url, reviewers: ["mo10sa10"])

				message.reply("Hello!!")
			end
		end
	end
end

