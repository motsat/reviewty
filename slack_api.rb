class SlackAPI

  def client
    @client ||= Slack::Client.new(token: ENV['SLACK_TOKEN'])
  end

  def users_list
    @users_list ||= client.users_list
  end

  def reset_users_list
    @users_list = nil
  end

  def find_member_by_id(slack_member_id)
    users_list["members"].find do |member|
      member["id"] == slack_member_id
    end
  end

  def find_member_by_name(realname_or_email)
    users_list["members"].find do |member|
      member_realname_or_emails = [member["name"]] # realname..?
        member_realname_or_emails.include? realname_or_email
    end
  end
end
