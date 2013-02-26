class BranchesController < ApplicationController

  layout 'recipes'

  before_filter :login_required

  helper :recipes, :categories

  def new
    @orig_recipe = Recipe.find_by_id(params[:id]) || not_found
    @recipe = @orig_recipe.new_branch(current_user)
    @page_title = h(@orig_recipe.name) + ' - Forking Recipe'
  end

  def create
    @page_title = 'Recipes'
    @orig_recipe = Recipe.find_by_id(params[:original_recipe].to_i) || not_found
    Recipe.transaction do
      @recipe = Recipe.new
      @recipe.process_recipe(params, current_user)
      @recipe.created_by_id = current_user.id
      @recipe.attributes = params[:recipe]
      #deal with fork process
      #1. copy original image if new one not supplied
      if params[:recipe][:image].blank?
        @recipe.image = @orig_recipe.image
        @recipe.image.instance_write(:file_name, "#{@orig_recipe.to_param}.jpg")
      end
      #2. examine steps to check if new images supplied... if not then copy previous images to steps
      @recipe.clone_step_images_if_not_updated(params[:recipe][:steps_attributes])
      #deal with fork
      fork = @recipe.recipe_forks.first
      fork.fork = @recipe
      fork.at_rev = fork.origin.revisable_number
      if @recipe.save
        @recipe.calculate_nutrition
        @orig_recipe.create_action_user_activity('forked', current_user)
        @recipe.create_action_user_activity('forked', current_user)
        flash[:info] = "Recipe #{h @recipe.name} forked."
        redirect_to recipe_path(@recipe)
      else
        render :action => :new
      end
    end
  end

end
