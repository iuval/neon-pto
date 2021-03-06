module ViewHelper
  def avatar_url(user, opts = {size: 50})
    if user.avatar_url?
      user.avatar_url
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{opts[:size]}"
    end
  end

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-danger"
    when :alert then "alert alert-danger"
    end
  end

  def love_class(index, love)
    if index == love
      'btn-danger'
    else
      'btn-default'
    end
  end
end
