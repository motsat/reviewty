class Reviewer
  include Redis::Objects
  list :lists, global: true, marshal: true
  attr_reader :slack_member_id, :github_account, :tags

  def self.find_by_slack_member_id(slack_member_id)
    lists.find { |reviewer| reviewer[:slack_member_id] == slack_member_id }
  end

  def self.add(slack_member_id:, github_account:)
    # TODO lock and unique check
    vars = { slack_member_id: slack_member_id, github_account: github_account, last_reviewed_at: Time.now, tags: []}
    lists << vars
    Reviewer.new(vars)
  end

  def self.delete(slack_member_id:)
    reviewer = find_by_slack_member_id(slack_member_id)
    lists.delete reviewer if reviewer
  end

  def self.by_tag(tag)
    all.select { |reviwer| reviwer.has_tag? tag }
  end

  def self.all
    lists.map do |l|
      Reviewer.new(slack_member_id: l[:slack_member_id], 
                   github_account: l[:github_account], 
                   last_reviewed_at: l[:last_reviewed_at], 
                   tags: l[:tags])
    end
  end

  def has_tag?(tag)
    tags.include? tag
  end

  def to_s
    "slack_member_id: #{slack_member_id}, github_account: #{github_account} tags: #{tags.join"/ "}" 
  end

  private

  def initialize(slack_member_id:, github_account:, 
                 tags:, last_reviewed_at:)
    @slack_member_id = slack_member_id
    @github_account = github_account
    @tags = tags
    @last_reviewed_at = last_reviewed_at
  end
end
