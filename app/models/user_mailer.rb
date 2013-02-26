class UserMailer < ActionMailer::Base

  def self.set_home_from_request(request)
    default_url_options[:host] = "#{request.host_with_port}"
  end


  def welcome_email(new_user)
    setup_email(new_user)
    @subject  << "Welcome to RecipeTrees.com"
    @body[:user] = new_user
  end

  def notify_admins_signup(admins, new_user)
    set_email_header
    @subject    << 'New User Registration'
    @recipients = admins.inject([]){|result, admin| result << admin.email}
    @body[:user] = new_user
  end

  def contact_us(contact, admins, ip)
    set_email_header
    #override
    @from = contact[:email] unless contact[:email].blank?
    @recipients = admins.inject([]){|result, admin| result << admin.email}
    @subject << 'Contact Us'
    @contact = contact
    @ip = ip
  end

  def tried_your_recipe(current_user, recipe, other)
    setup_email(recipe.user)
    @subject    << "#{current_user.name} has tried your #{recipe.name} recipe"
    @body[:recipe] = recipe
    @body[:other] = other
    @body[:current_user] = current_user
    @body[:recipe_owner] = recipe.user
  end

  protected

  def setup_email(user)
    set_email_header
    @recipients  = "#{user.email}"
    @body[:user] = user
  end

  def set_email_header
    @from        = "do_not_reply@recipetrees.com"
    @subject     = "[RecipeTrees.com] - "
    @sent_on     = Time.now
    @content_type = "text/html"
  end

  

end
