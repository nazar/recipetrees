module RenderHelper

  def span(txt, options = nil)
    content_tag(:span, txt, options)
  end

  def strong(txt, options = nil)
    content_tag(:strong, txt, options)
  end

  def em(txt, options = nil)
    content_tag(:em, txt, options)
  end

end