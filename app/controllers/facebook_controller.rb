class FacebookController < ApplicationController

  def callback
    @oauth = Koala::Facebook::OAuth.new( facebook_callback_url(:callback_option => 'connect') )
    case params[:callback_option].downcase
      when 'connect': do_connect
    end
  end


  protected

  def do_connect
    token = @oauth.get_access_token(params[:code])
    if token.blank?
      flash[:error] = 'Facebook Connect Failed'
      redirect_to login_path
    else
      session[:token] = token
      graph = Koala::Facebook::GraphAPI.new(token)
      facebook_info = graph.get_object("me")
      self.current_user = User.facebook_register_user_from_graph(facebook_info, request)
      flash[:info] = "Hi #{self.current_user.name}, you've successfully logged in."
      redirect_to account_path
    end
  end

end
