module ApplicationHelper
  def app_name
    Settings.app_name
  end

  def flash_alert_class(key)
    case key
    when 'notice'
      :success
    when 'alert'
      :danger
    else
      :info
    end
  end
end
