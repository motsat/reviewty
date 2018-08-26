class Parser
  attr_reader :message
  def initialize(message)
    @message = message
  end
  def parse
    raise "abstruct method"
  end
end

class AssignParser < Parser
  def parse
    vars = message.body.squish.split " "
    group, pull_request_url = 
      case vars.size
      when 3
        return [nil, vars[2]]
      when 4
        return [vars[2], vars[3]]
      else
        raise
      end
  end
end

class ListsParser < Parser
  def parse
    raise NotImplementedError "No need for now"
  end
end

class UserAddParser < Parser
  def parse
    vars = message.body.squish.split " "
    # [0]はbot自身、[1]は対象ユーザー
    slack_member_id =  message.original[:mention_to][1]["id"]
    github_account = vars[3]
    [slack_member_id, github_account]
  end
end

class UserDelParser < Parser
  def parse
    vars = message.body.squish.split " "
    # [0]はbot自身、[1]は対象ユーザー
    message.original[:mention_to][1]["id"]
  end
end

class ChTagsParser < Parser
  def parse
    vars = message.body.squish.split " "
    [vars[2].gsub(/^@/,""), vars[3..-1]] # 1.slack_realname or email, 2.tags
  end
end

