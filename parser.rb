class Parser
  attr_reader :message
  def initialize(message)
    @message = message
  end
  def parse
    raise "abstruct method"
  end
end

class UserDelParser < Parser
  def parse
  end
end

class ChTagsParser < Parser
  def parse
    vars = message.body.squish.split " "
    [vars[2].gsub(/^@/,""), vars[3..-1]] # 1.slack_realname or email, 2.tags
  end
end

