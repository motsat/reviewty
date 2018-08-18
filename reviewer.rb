class Reviewer
  include Redis::Objects
  list :lists, global: true, marshal: true
  attr_reader :slack_member_id, :github_account

  def self.find_by_slack_member_id(slack_member_id)
    lists.find { |reviewer| reviewer[:slack_member_id] == slack_member_id }
  end

  def self.add(slack_member_id:, github_account:)
    # TODO lock and unique check
    vars = { slack_member_id: slack_member_id, github_account: github_account }
    lists << vars
    Reviewer.new(vars)
  end

  def self.delete(slack_member_id:)
    reviewer = find_by_slack_member_id(slack_member_id)
    lists.delete reviewer if reviewer
  end

  def self.all
    lists.map do |l|
      Reviewer.new(slack_member_id: l[:slack_member_id], github_account: l[:github_account])
    end
  end

  def to_s
    "slack_member_id: #{slack_member_id}, github_account: #{github_account}" 
  end

  private

  def initialize(slack_member_id:, github_account:)
    @slack_member_id = slack_member_id
    @github_account = github_account
  end
end
