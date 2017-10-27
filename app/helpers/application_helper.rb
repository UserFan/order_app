module ApplicationHelper
  def active_class(link_path)
    request.original_url == link_path ? "active" : "redfdf"
  end
end
