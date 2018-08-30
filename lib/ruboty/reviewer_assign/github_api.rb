module Ruboty
  module ReviewerAssign
    class GithubAPI
      def assign_reviewer(pull_request_url, reviewer_accounts)
        id = pull_request_id_by_url(pull_request_url)
        octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY"], id, reviewers: reviewer_accounts)
      end

      private
      def pull_request_id_by_url(pull_request_url)
        pull_request_url.split("/").last
      end

      def octokit
        # https://github.com/octokit/octokit.rb
        # Given $OCTOKIT_API_ENDPOINT
        @octokit ||= Octokit::Client.new(access_token: ENV["OCTOKIT_ACCESS_TOKEN"])
      end
    end
  end
end
