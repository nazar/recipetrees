class IngredientsController < ApplicationController

  before_filter :login_required, :only => [:edit, :update, :category_update]

  cache_sweeper :ingredient_sweeper, :only => [:create, :update, :destroy]


  def index
    @page_title = 'Ingredients Database'
    @page_title << " - Page #{params[:page]}" unless params[:page].blank?
    @ingredients = Ingredient.by_name.paginate :include => [:nutrition], :page => params[:page]
  end

  def filter
    @page_title = "Ingredients Database - Filtering by Letter #{params[:id]}"
    @page_title << " - Page #{params[:page]}" unless params[:page].blank?
    @ingredients = Ingredient.by_name.by_alphabet(params[:id]).paginate :include => [:nutrition], :page => params[:page]
    #
    render :action => :index
  end

  def by_category
    id = Ingredient.ingredient_groups.index(params[:id])
    not_found unless id.to_i > 0
    @ingredients = Ingredient.by_name.by_category(id).paginate :page => params[:page]
    @page_title = "Ingredients Database - #{params[:id].humanize}"
    render :action => :index
  end

  def edit
    @ingredient = Ingredient.find_by_id params[:id]
    @page_title = @ingredient.name + ' - Editing'
  end

  def update
    @ingredient = Ingredient.find_by_id params[:id]
    Ingredient.transaction do
      @ingredient.attributes = params[:ingredient]
      @ingredient.updated_by_id = current_user.id
      if @ingredient.save
        flash[:flash] = 'Ingredient updated.'
        @ingredient.create_action_user_activity('updated', current_user)
        redirect_to ingredient_path(@ingredient)
      else
        @page_title = @ingredient.name + ' - Editing'
        render :action => :edit
      end
    end
  end

  def show
    @ingredient = Ingredient.grouped.find_by_id(params[:id].to_i) || not_found
    @ingredient.hit_views!  unless ignore_hit
    @relations = @ingredient.related_ingredients
    @recipes = @ingredient.recipes.by_name.paginate :include => [:tags, :categories], :page => params[:page], :per_page => 10
    #get related recipes if relations > 1
    @related_recipes = Recipe.by_name.published.related_recipes_to_ingredient(@ingredient).paginate :include => [:tags, :categories], :page => params[:related_page], :per_page => 10
    #
    @page_title = h(@ingredient.name) + ' - Ingredient'
    @meta_description = @ingredient.description || h(@ingredient.name)
  end
  
  def get_for_ajax
    if params[:term] && params[:term].length > 1
      if params[:id]
        @ingredients = Ingredient.name_search(params[:term]).by_name.not_id(params[:id])
      else
        @ingredients = Ingredient.name_search(params[:term]).by_name
      end
    else
      @ingredients = []
    end
    render :text => @ingredients.to_json(:only => :id, :methods => [:label, :value])
  end

  def commented
    count = params[:count].to_i
    ing = Ingredient.find_by_id(params[:id])
    unless ing.blank?  #doing it like this to avoid recipe's before_save callback
      Ingredient.update_all(["posts_count = ?", count], "ingredients.id = #{ing.id}" )
      unless current_user.blank?
        ing.create_action_user_activity('commented', current_user)
      end
    end
    render :nothing => true, :status => 200
  end

  def image
    @ingredient = Ingredient.find_by_id params[:id]
    unless @ingredient.blank?
      respond_to do |format|
        format.html{
          @page_title = @ingredient.name
          render :layout => 'for_images'
        }
        format.js{render :inline => "<div class='step_thumbnail'><%= image_tag @ingredient.image.url(:original), :class => 'step_thumbnail' %></div>"}
      end
    else
      render :nothing => true
    end
  end

  def category_update
    render :noting => true and return unless admin?
    ingredient = Ingredient.find_by_id(params[:id]) || not_found
    ingredient.ingredient_group = params[:group]
    ingredient.save(:without_revision => true)
    respond_to do |format|
      format.html{redirect_to ingredient_path(ingredient)}
      format.js  {render :nothing => true, :status => 200}
    end
  end

  def delete
    ingredient = Ingredient.find_by_id(params[:id].to_i) || not_found
    redirect_to ingredient_path(ingredeient) unless admin?
    Ingredient.transaction do
      ingredient.destroy
      redirect_to ingredients_path
    end

  end





end
