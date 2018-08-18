class User
  include Redis::Objects
  list :lists, global: true

  def self.add(slack_member, github_account)
  end

  def self.all
    lists.map do |l|
      User.new(slack_id: l["id"], github_account: l["github_account"])
    end
  end

  private
  attr_accessor :slack_id, :github_account

  def initialize(slack_id:, github_account:)
    @slack_id = slack_id
    @slack_id = github_account
  end
end
