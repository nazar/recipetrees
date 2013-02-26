class BlogsController < ApplicationController

  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]

  def index
    @page_title = 'Blogs'

    @blogs = Blog.by_date.paginate :include => :user, :page => params[:page]
  end

  def show
    @blog = Blog.find_by_id(params[:id].to_i) || not_found
    @blog.hit_views!(current_user)  unless ignore_hit

    @page_title = h(@blog.title) + ' - Blogs'
    @meta_description = @blog.body
  end

  def new
    @blog = Blog.new
  end

  def edit
    @page_title = 'Blogs'
    @blog = Blog.find_by_id(params[:id].to_i) || not_found
  end

  def create
    @blog = Blog.new params[:blog]
    @blog.user_id = current_user.id
    Blog.transaction do
      if @blog.save
        @blog.create_action_user_activity('created', current_user)
        post_to_facebook_wall(:added, @blog, true, true)
        flash[:flash] = 'Blog created.'
        redirect_to blog_path(@blog)
      else
        render :action => :new
      end
    end
  end

  def update
    @blog = Blog.find_by_id(params[:id].to_i)
    @blog.attributes= params[:blog]
    Blog.transaction do
      if @blog.save
        @blog.create_action_user_activity('updated', current_user)
        flash[:flash] = 'Blog updates.'
        redirect_to blog_path(@blog)
      else
        render :action => :edit
      end
    end
  end

  def destroy

  end

end
