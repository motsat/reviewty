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

  def find_by_realname_or_email(realname_or_email)
    users_list["members"].find do |member|
      member_realname_or_emails = 
        [member["profile"]["real_name"],
         member["profile"]["real_name_normalized"],
         member["profile"]["display_name"],
         member["profile"]["email"]
      ]
        member_realname_or_emails.include? realname_or_email
    end
  end
end
