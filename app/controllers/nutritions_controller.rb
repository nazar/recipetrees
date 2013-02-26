class NutritionsController < ApplicationController

  before_filter :login_required, :only => [:new, :create, :update, :edit]

  def new
    @ingredient = Ingredient.find_by_id(params[:ingredient_id].to_i) || not_found
    #get all foods from Fat Secret
    @foods = Nutrition.get_foods_from_fs_for_ingredient(@ingredient)
    render :layout => false
  end

  def servings
    @ingredient = Ingredient.find_by_id(params[:ingredient]) || not_found
    @servings = Nutrition.get_servings_for_food_id(params[:food_id])
    render :layout => false
  end

  def create
    Nutrition.transaction do
      ingredient = Ingredient.find_by_id(params[:ingredient_id].to_i) || not_found
      nutrient = ingredient.nutrition || ingredient.build_nutrition
      nutrient.added_by_id   = current_user.id
      nutrient.update_from_params(params[:nutrition])
      nutrient.save
      #
      ingredient.food_id = params[:food_id]
      ingredient.save
      #
      render :nothing => true, :status => 200
    end
  end

end
