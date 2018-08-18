class User
  include Redis::Objects
  list :lists, global: true, marshal: true

  def self.add(slack_member_id:, github_account:)
    # TODO lock and unique check
    vars = { slack_member_id: slack_member_id, github_account: github_account }
    lists << vars
    User.new(vars)
  end

  def self.all
    lists.map do |l|
      User.new(slack_member_id: l["id"], github_account: l["github_account"])
    end
  end

  private
  attr_accessor :slack_member_id, :github_account

  def initialize(slack_member_id:, github_account:)
    @slack_member_id = slack_member_id
    @github_account = github_account
  end
end
