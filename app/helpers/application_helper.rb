# Courseware helpers
module ApplicationHelper
  # Helper to set page title
  #
  # @param page_title {String}
  def title(page_title)
    content_for :title, page_title.to_s
  end

  # Helper to set embeds in HEAD
  #
  # @param content, ebeds content
  def head_embed(content)
    content_for :head_embed, content if content
  end
end
