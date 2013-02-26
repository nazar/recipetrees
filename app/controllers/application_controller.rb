class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  helper :render, :blogs

  helper_method :textile_to_text, :from_textile, :strip_tags, :rails_in_development

  protect_from_forgery

#  before_filter :login_from_cookie

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


  class Utility
    def self.robot?(user_agent)
      user_agent =~ /(Baidu|bot|Google|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg|facebook)/i
    end
  end



  protected


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def rails_in_development
    RAILS_ENV == 'development'
  end

  def post_to_facebook_wall(action, obj, user_wall, app_wall)
    return if rails_in_development
    spawn :kill => true do
      if app_wall
        post_to_app_wall(action, obj)
      end
      #post to user wall
      if user_wall
        picture = obj.respond_to?('image') ? request.protocol + request.host_with_port + obj.image(:thumbnail) : ''
        message = {'name' => h(obj.name), 'link' => polymorphic_url(obj), 'picture' => picture}
        unless facebook_cookies['access_token'].blank?
          graph = Koala::Facebook::GraphAPI.new(facebook_cookies['access_token'])
          begin
            graph.put_wall_post("#{obj.user.name} #{action.to_s} #{h(obj.name)}", message )
            if obj.respond_to?('facebook_published_at')
              obj.class.update_all(['facebook_published_at = ?',Time.now], ['id = ?', obj.id])
            end
          rescue Koala::Facebook::APIError
            #TODO setting flash here is pretty stupid... as this finishes after user has got the page
            #flash[:error] = "Recipe was saved but not posted on your Facebook profile. Please <a href='/login'>re-login</a> to fix."
          end
        end
      end
    end
  end

  def post_to_app_wall(action, obj)
    #post to app wall
    oauth = Koala::Facebook::OAuth.new( facebook_callback_url(:callback_option => 'connect') )
    graph = Koala::Facebook::GraphAPI.new(oauth.get_app_access_token_info['access_token'])
    picture = obj.respond_to?('image') ? request.protocol + request.host_with_port + obj.image(:thumbnail) : ''
    message = {'name' => h(obj.name), 'link' => polymorphic_url(obj), 'picture' => picture}
    #disabled for time being... post to user's wall only
    graph.put_wall_post("#{obj.user.name} #{action.to_s} #{h(obj.name)}", message, '191116444251564' )
    if obj.respond_to?('facebook_app_published_at')
      #speed over beauty
      obj.class.update_all(['facebook_app_published_at = ?',Time.now], ['id = ?', obj.id])
    end
  end


  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end

  def ignore_hit
    request.xhr? || Utility.robot?(request.user_agent)
  end

  def textile_to_text(body, limit = 200)
    unless body.blank?
      rc = RedCloth.new(body)
      stripped = CGI.unescapeHTML(strip_tags(rc.to_html))
      stripped.length > limit ? stripped.slice(0..limit) + '...' : stripped.slice(0..limit)
    end
  end

  def from_textile(body)
    RedCloth.new(body, [:filter_html]).to_html unless body.blank?
  end

  def strip_tags(html)
    return html if html.empty? || !html.include?('<')
    output    = ""
    tokenizer = HTML::Tokenizer.new(html)
    while token = tokenizer.next
      node = HTML::Node.parse(nil, 0, 0, token, false)
      output += token unless (node.kind_of? HTML::Tag) or (token =~ /^<!/)
    end
    output
  end




end
