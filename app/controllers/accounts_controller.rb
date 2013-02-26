class AccountsController < ApplicationController

  helper :feed

  before_filter :login_required

  def show
    @page_title = "#{current_user.name} - My Account"

    @recipes = current_user.recipes.by_name.paginate :include => [:tags, :categories], :page => params[:recipe_page], :per_page => 10
    @stream  = Activity.recent.by_users(current_user.i_am_following_user_ids + [current_user.id]).paginate :include => [:item, :user], :page => params[:activity_page]
    @blogs   = current_user.blogs.by_date.paginate :page => params[:blogs_page]
    @drafts  = current_user.recipes.draft.by_name :include => [:tags, :categories]
    @badges  = current_user.achievements.order('level DESC, level_name ASC')
    @graph   = open_flash_chart_object('100%',600, "/charts/reputation/#{current_user.id}")
  end

  def about
    user = User.find_by_id(current_user.id) || not_found
    user.bio = params[:about_me]
    user.save
    #
    redirect_to account_path
  end



end
