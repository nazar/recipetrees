class PagesController < ApplicationController

  #cache all controller

  #TODO disable caching as the user menu gets messed up
  #caches_action :about, :contact, :copyrights, :privacy

  def home
    @page_title = 'Welcome to Recipe Trees'
    @recipes = Recipe.latest.original.active.published.limit(4).all :include => :tags
  end

  def about
    @page_title = 'About Recipe Trees'
  end

  def contact
    @page_title = 'Contact Us'
    @contact = params[:contact] || {}
    return unless request.post?
    UserMailer.deliver_contact_us(@contact, User.admins, request.remote_ip)
    redirect_to '/pages/message_sent'
  end

  def copyrights
    @page_title = 'Copyright Policy'
  end

  def privacy
    @page_title = 'Privacy Policy'
  end

end
