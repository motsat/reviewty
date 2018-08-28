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
