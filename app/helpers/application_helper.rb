module ApplicationHelper
  def active_class(link_path)
    request.original_url == link_path ? "active" : "redfdf"
  end

  def flash_class(level)
      case level
        when 'notice' then "alert alert-info"
        when 'success' then "alert alert-success"
        when 'error' then "alert alert-danger"
        when 'alert' then "alert alert-warning"
      end
    end

end
