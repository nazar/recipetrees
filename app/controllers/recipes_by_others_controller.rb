class RecipesByOthersController < ApplicationController

  before_filter :login_required, :except => [:index, :image, :new]

  def index

  end

  def new
    @recipe = Recipe.find_by_id(params[:recipe_id].to_i) || not_found
    @by_others = @recipe.by_others.build
    @by_others.images.build

    respond_to do |format|
      format.html {
        redirect_to login_path if current_user.blank?
      }
      format.js {
        if current_user
          render :layout => false
        else
          render :file => '/session/login', :layout => false;
        end
      }
    end
  end

  def create
    @recipe = Recipe.find_by_id(params[:recipe_id].to_i) || not_found
    unless params[:recipe_by_others][:comments].blank? && params[:images][:picture].blank?
      Recipe.transaction do
        by_others = @recipe.by_others.create(params[:recipe_by_others].merge(:user_id => current_user.id))
        by_others.images.create(params[:images])
        #notify
        UserMailer.set_home_from_request(request)
        UserMailer.deliver_tried_your_recipe(current_user, @recipe, by_others)
        #FB
        post_other_to_app_wall@recipe, (by_others)
        #
        redirect_to recipe_path(@recipe, :anchor => 'by_others')
      end
    else
      redirect_to recipe_path(@recipe, :anchor => 'by_others')
    end
  end

  def delete

  end

  def image
    @other = RecipeByOthers.find_by_id params[:id]
    unless @other.blank?
      respond_to do |format|
        format.html {
          render :layout => 'for_images'
        }
        format.js {
          render :inline => "<div class='step_thumbnail'><%= image_tag @other.images.first.picture.url(:original) %></div>"
        }
      end
    else
      render :nothing => true
    end
  end


  protected

  def post_other_to_app_wall(recipe, by_other)
    return if rails_in_development
    spawn :kill => true do
      oauth = Koala::Facebook::OAuth.new( facebook_callback_url(:callback_option => 'connect') )
      graph = Koala::Facebook::GraphAPI.new(oauth.get_app_access_token_info['access_token'])

      picture = request.protocol + request.host_with_port + by_other.images.first.picture(:thumbnail)
      message = {'name' => h(recipe.name), :description => from_textile(by_other.comments), 'link' => recipe_url(recipe, :anchor => 'by_others'), :picture => picture}
      #
      graph.put_wall_post("#{by_other.user.name} tried #{recipe.user.name}'s #{h(recipe.name)} recipe.", message, '191116444251564' )
    end
  end

end
