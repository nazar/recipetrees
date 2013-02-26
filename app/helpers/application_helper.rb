module ApplicationHelper

  include TagsHelper

  def jquery_include_tag(*libs)
    js_libs = []
    js_opts = {}
    libs.each do |library|
      case
        when library.is_a?(String)
          js_libs << "jquery/#{library}"
        when library.is_a?(Hash)
          js_opts.merge!(library)
      end
    end
    javascript_include_tag js_libs, js_opts
  end

  def get_page_title
    result = @meta_title || @page_title
    result << ' - RecipeTrees.com' unless result.blank?
  end

  def panel(id, &block)
    panel_class = "panel_#{id}"
    result = content_tag(:div, :class => panel_class) do
      content_tag(:div, capture(&block), :class => 'panel_content') +
          content_tag(:div, '&nbsp;', :class => 'end')
    end
    concat(result)
  end

  def default_navigation

    add_item do |i|
      i.named span('Home')
      i.links_to hash_for_home_path
    end

    add_item do |i|
      i.named span('About')
      i.titled 'About Recipe Trees'
      i.links_to hash_for_about_page_path
    end

    add_item do |i|
      i.named span('Recipes')
      i.html = {:class => 'submenu'}
      i.links_to hash_for_recipes_path
    end

    add_item do |i|
      i.named span('Ingredients')
      i.links_to hash_for_ingredients_path
    end

    add_item do |i|
      i.named span('Blogs')
      i.links_to hash_for_blogs_path
    end

    add_item do |i|
      i.named span('Feed')
      i.links_to hash_for_feed_page_path
    end

    add_item do |i|
      i.named span('Contact')
      i.links_to hash_for_contact_page_path
    end
  end

  def show_adds(user)
    false
  end

  def oauth
     Koala::Facebook::OAuth.new( facebook_callback_url( :callback_option => 'connect' ) )
  end

  def url_for_oauth
    oauth.url_for_oauth_code(:permissions => 'email,user_about_me,publish_stream')
  end

  def display_flash
    #TODO render both
    render :partial => '/shared/highlight', :locals => {:message => flash[:info]}  if flash[:info]
    render :partial => '/shared/alert', :locals => {:message => flash[:error]} if flash[:error]
  end

  def path_to_url(path)
    request.protocol + request.host_with_port + path
  end

  def icon_text_button(link, image, text, options={})
    link_to(image, link, options[:options_link]) + '<br />' + link_to(text, link, options[:options_link])
  end


end
