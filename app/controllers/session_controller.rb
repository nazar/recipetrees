class SessionController < ApplicationController

  before_filter :login_required, :only => [:logout]

  def index
    redirect_to(:action => 'login') unless logged_in? || User.count > 0
  end

  def login
    @page_title = 'Login'
    @oauth = Koala::Facebook::OAuth.new( facebook_callback_url( :callback_option => 'connect' ) )
  end

  def logout
    cookies.delete "_recipes.git_session"
    cookies.delete :auth_token
    cookies.delete "fbs_" + Facebook::APP_ID.to_s
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/')
  end


  protected


  def save_created_user(user, &block)
    User.transaction do
      user.name      = user.login #default real name to login
      user.active    = true
      user.save
      #
      user.initialise_counters if user.errors.blank?
      #post processing in block
      block.call(user)
    end
  end


end