module BlogsHelper

  def truncate_with_more_link(item, limit = 50)
    #body is in textile format.... to html then strip
    body = strip_tags(from_textile(item.body))
    if body.length > limit
      body = truncate(body, :length => limit)
      #check if there is a closing /p... sneak in the read more there
      body = body + link_to('..read more', blog_path(item), :class => 'more')
      #good chance here that HTML is broken due to truncation... run it though HTML TIDY
      Tidy.path = File.join(Rails.root,'bin/libtidy.so')
      body = Tidy.open{|tidy| tidy.options.show_body_only=true; tidy.clean(body)}
    else
      body = from_textile(item.body)
    end
    body
  end


end
