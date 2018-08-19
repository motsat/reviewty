class GithubAPI
  def assign_reviewer(pull_request_url)
    id = pull_request_id_by_url(pull_request_url)
    octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY"], id, reviewers: ["mo10sa10"])
  end

  private
  def pull_request_id_by_url(pull_request_url)
    pull_request_url.split("/").last
  end

  def octokit
    @octokit ||= Octokit::Client.new(access_token: ENV["OCTOKIT_ACCESS_TOKEN"])
  end
end
