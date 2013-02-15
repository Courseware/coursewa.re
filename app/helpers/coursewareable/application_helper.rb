module Coursewareable
  # Courseware helpers
  module ApplicationHelper
    # Helper to set page title
    #
    # @param [String] page_title
    def title(page_title)
      content_for(:title, page_title) if page_title
    end

    # Helper to set embeds in HEAD
    #
    # @param [String] content
    def head_embed(content)
      content_for(:head_embed, content) if content
    end

    # Helper to set breadcrumbs content
    #
    # @param [String] content
    def breadcrumbs(content)
      content_for(:breadcrumbs, content) if content
    end

    # Helper to render the classroom header image
    # Defaults to a randomly provided image
    #
    # @return [String], generated style tag with CSS
    def header_image
      return if @classroom.nil? or @classroom.new_record?

      image = @classroom.images.find_by_id(@classroom.header_image)
      return if image.nil?

      @header_image = image.attachment.url
      render('shared/header_image')
    end

    # Generates a random header image from available list
    # Uses last classroom digit from it's ID
    #
    # @return [String], generated style tag with CSS
    def default_header_image
      return if @classroom.nil? or @classroom.new_record?

      image_id = @classroom.id % 10

      # Since we have only 1..7 available headers, lets map what doesn't fit
      image_id = 7 if image_id == 0 or image_id > 7
      @header_image = path_to_image("headers/#{image_id}.jpg")
      render('shared/header_image')
    end

    # Turns all http(s) URLs into HTML content if URL is an oembed link
    #
    # @param [String] text, the text to be checked for URLs
    # @return [String], the updated `text` with oembed content
    def auto_oembed(text)
      return ''.html_safe if text.blank?

      content = {}
      urls = URI.extract(text, %w(http https))

      return text.html_safe unless urls.count > 0

      urls.each do |url|
        html = fetch_and_render_oembed(url)
        content[url] = html unless html.blank?
      end

      content.each_pair do |key, value|
        text.sub!(key, value)
      end

      return text.html_safe
    end

    private

    # Tries to fetch `url` content from oembed providers
    # On success renders a partial from `shared/auto_oembed` based on
    # provider response type.
    #
    # @param [String] url, the URL to be checked
    # @return [String], the rendered partial content
    def fetch_and_render_oembed(url)
      begin
        response = OEmbed::Providers.get(url.to_str)
      rescue
        response = nil
      end

      render(
        :partial => "auto_oembed/#{response.type}",
        :locals => {:oembed => response}
      ) unless response.nil?
    end

  end
end
