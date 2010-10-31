module ProfilePlus
  module NotifierMixin

    def marketing_sign_up_thank_you(profile_id)
      profile = Profile.find(:first, :conditions => ['id = ?', profile_id])
      user = profile.nil? ? nil : profile.user

      recipient_email profile.email
      recipients profile.email
      load_site_email_attributes
      @body = parse_site_email({'user' => UserDrop.new(user, profile) })
    end

    def register_thank_you(profile_id)
      profile = Profile.find(:first, :conditions => ['id = ?', profile_id])
      user = profile.nil? ? nil : profile.user

      recipient_email profile.email
      recipients profile.email
      load_site_email_attributes
      @body = parse_site_email({'user' => UserDrop.new(user, profile) })
    end

    def send_request_password(profile_id, request_url)
      profile = Profile.find(:first, :conditions => ["id = ?", profile_id])
      data_hash = {
        'email' => profile.email,
        'user' => UserDrop.new(profile.user, profile),
        'request_url' => request_url
      }

      recipient_email data_hash['email']
      recipients data_hash['email']
      load_site_email_attributes
      @body = parse_site_email(data_hash)
    end

  end
end

