class TipsController < ApplicationController

  caches_action :recipe_categories, :recipe_description, :recipe_image, :recipe_ingredient, :recipe_ingredient_action, :recipe_ingredient_type,
                :recipe_measure, :recipe_step_action, :recipe_step_stage, :recipe_step_time, :recipe_steps, :recipe_tags, :recipes_ingredients

end
