class RecipesController < ApplicationController

  helper :categories, :ingredients, :steps, :branches, :cuisines, :rt_tags

  before_filter :login_required, :except => [:index, :show, :commented, :image, :filter, :print]

  cache_sweeper :recipe_sweeper, :only => [:create, :update, :destroy]

  def index
    @page_title = 'Recipes'
    #reset filter session
    session[:filter] = nil
    #
    @recipes_scope = Recipe.published
    @recipe_title = ''
    @recipes = Recipe.active.published.latest.paginate :include => [:tags, :categories], :page => params[:page]
  end

  def show
    respond_to do |format|
      format.html {
        @recipe = Recipe.find_by_id params[:id].to_i,
            :include => [:steps, :categories, :watchers,
                         {:recipe_ingredients => [:recipe_item, :measure]},
                         {:recipes_used_in_this => [:steps, {:recipe_ingredients => [:recipe_item, :measure]}]}]
        @by_others = @recipe.by_others.latest.paginate :include => [:images, :user], :page => params[:by_others_page]
        #only recipe owner can see draft recipes
        if @recipe.is_draft && (not @recipe.my_recipe(current_user))
          not_found
        end
        @page_title = h @recipe.name
        @meta_description = @recipe.description
        unless @recipe.blank?
          @forks = @recipe.forks
          #stats
          @recipe.hit_views!(current_user) unless ignore_hit
        else
          redirect_to recipes_path
        end
      }
      format.js {
        @recipe = Recipe.find_by_id params[:id]
        render :partial => 'render_for_ajax'
      }
    end
  end

  def new
    @page_title = 'Adding a new recipe'

    @recipe = Recipe.new(:serves_from => 1)
  end

  def create
    @page_title = 'Recipes'
    Recipe.transaction do
      @recipe = Recipe.new
      @recipe.process_recipe(params, current_user)
      @recipe.created_by_id = current_user.id
      @recipe.attributes = params[:recipe]
      @recipe.tag_list = white_list(params[:recipe][:tag_list])
      Recipe.draft = @recipe
      if @recipe.save
        unless @recipe.is_draft
          #doesn't seem to be doing this correctly in before_save in recipe
          @recipe.calculate_nutrition
          @recipe.save
          @recipe.create_action_user_activity('added', current_user)
          post_to_facebook_wall(:added, @recipe, ! params[:facebook_publish].blank?, ! params[:facebook_app_publish].blank?)
        end
        flash[:info] = "Recipe #{h @recipe.name} created."
        redirect_to recipe_path(@recipe)
      else
        render :action => :new
      end
    end
  end

  def update
    @page_title = 'Recipes'
    @recipe = Recipe.find_by_id params[:id]
    unless @recipe.blank?
      Recipe.transaction do
        @recipe.process_recipe(params, current_user)
        @recipe.attributes = params[:recipe]
        @recipe.tag_list = white_list(params[:recipe][:tag_list])
        Recipe.draft = @recipe
        if @recipe.save
          unless @recipe.is_draft
          #doesn't seem to be doing this correctly in before_save in recipe
            @recipe.calculate_nutrition
            @recipe.save
            if @recipe.facebook_published_at.blank?
              @recipe.create_action_user_activity('added', current_user)
              post_to_facebook_wall(:added, @recipe, ! params[:facebook_publish].blank?, ! params[:facebook_app_publish].blank?)
            else
              @recipe.create_action_user_activity('updated', current_user)
            end
          end
          flash[:info] = "Recipe #{h @recipe.name} updated."
          redirect_to recipe_path(@recipe)
        else
          render :action => :edit
        end
      end
    else
      redirect_to recipes_path
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @page_title = h(@recipe.name) + ' - Editing'
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    #TODO
  end

  def commented
    count = params[:count].to_i
    recipe = Recipe.find_by_id(params[:id].to_i)
    unless recipe.blank?  #doing it like this to avoid recipe's before_save callback
      Recipe.update_all(["posts_count = ?", count], "recipes.id = #{recipe.id}" )
      unless current_user.blank?
        recipe.create_action_user_activity('commented', current_user)
      end
    end
    render :nothing => true, :status => 200
  end

  def image
    @recipe = Recipe.find_by_id params[:id]
    unless @recipe.blank?
      respond_to do |format|
        format.html {
          @page_title = "Image of #{@recipe.name}"
          render :layout => 'for_images'
        }
        format.js {
          render :inline => "<div class='step_thumbnail'><%= image_tag @recipe.image.url(:original), :alt => @recipe.name %></div>"
        }
      end
    else
      render :nothing => true
    end
  end

  def watch
    @recipe = Recipe.find_by_id(params[:id].to_i) || not_found
    Recipe.transaction do
      RecipeWatcher.add_watcher(@recipe, current_user)
      @recipe.create_action_user_activity('watched', current_user)
      #TODO post to app wall
      redirect_to recipe_path(@recipe)
    end
  end

  def get_for_ajax
    if params[:term] && params[:term].length > 1
      if params[:id]
        @recipes = Recipe.name_search(params[:term]).by_name.not_id(params[:id])
      else
        @recipes = Recipe.name_search(params[:term]).by_name
      end
    else
      @recipes = []
    end
    render :text => @recipes.to_json(:only => :id, :methods => [:label, :value])
  end

  def filter
    if params[:filter].blank? && params[:recipe_title].blank?
      session[:filter] = nil
      #
      redirect_to recipes_path
    else
      @page_title = 'Filtering Recipes'

      session[:filter] = params[:filter]
      @recipe_title = params[:recipe_title] || '' #don't really need this in session

      category_ids, ingredient_ids, cuisine_ids, tag_names = split_filter_array(params[:filter]) unless params[:filter].blank?

      redirect_to recipes_path and return if category_ids.blank? && ingredient_ids.blank? &&
                  cuisine_ids.blank? && tag_names.blank? && @recipe_title.blank?

      @recipes_scope = Recipe.decide_scope(ingredient_ids, category_ids, cuisine_ids, tag_names, @recipe_title)
      @recipes = @recipes_scope.paginate  :include => [:tags, :categories], :page => params[:page]

      render :action => :index
    end
  end

  def print
    @recipe = Recipe.find_by_id params[:id].to_i,
        :include => [:steps, :categories,
                     {:recipe_ingredients => [:recipe_item, :measure]},
                     {:recipes_used_in_this => [:steps, {:recipe_ingredients => [:recipe_item, :measure]}]}]
    @page_title = h @recipe.name

    render :layout => 'print'
  end

  def to_app_wall
    if current_user.admin?
      @recipe = Recipe.find_by_id(params[:id].to_i) || not_found
      Recipe.transaction do
        post_to_app_wall(:added, @recipe)
      end
      redirect_to recipe_path(@recipe)
    end
  end

  protected

  def split_filter_array(params)
    categories  = Category.select_from_filter(params)
    ingredients = Ingredient.select_from_filter(params)
    cuisines    = Cuisine.select_from_filter(params)
    tags        = params.select{|a| a =~ /^t:/} #do these here as tag is plugin
    #
    category_ids   = Category.get_ids_from_filter(categories)
    ingredient_ids = Ingredient.get_ids_from_filter(ingredients)
    cuisine_ids    = Cuisine.get_ids_from_filter(cuisines)
    tag_ids        = tags.collect{|x| x.match('^t:(\d+):')[1] }
    #
    return category_ids, ingredient_ids, cuisine_ids, tag_ids
  end


end
