module ApplicationHelper
  # Helper to set page title
  #
  # @param page_title {String}
  def title(page_title)
    content_for :title, page_title.to_s
  end
end
