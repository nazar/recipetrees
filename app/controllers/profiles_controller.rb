class ProfilesController < ApplicationController

  helper :feed

  before_filter :login_required, :only => [:follow]

  def index
    redirect_to root_path
  end

  def show
    @user = User.find_by_id params[:id].to_i
    unless @user.blank?
      @page_title = "#{@user.name} - Viewing Profile"
      #
      @recipes = @user.recipes.published.by_name.paginate :include => [:tags, :categories], :page => params[:recipe_page], :per_page => 10
      @tags    = @user.recipes.tag_counts
      @stream  = Activity.recent.by_users(@user).paginate :include => :item, :page => params[:activity_page]
      @blogs   = @user.blogs.by_date.paginate :page => params[:blogs_page]
      @badges  = @user.achievements.order('level DESC, level_name ASC')
      @graph   = open_flash_chart_object('100%',600, "/charts/reputation/#{@user.id}")
    else
      redirect_to root_path
    end
  end

  def follow
    user = User.find_by_id(params[:id].to_i) || not_found
    User.transaction do
      Follower.add_follower(current_user, user)
      redirect_to profile_path(user)
    end
  end

end
