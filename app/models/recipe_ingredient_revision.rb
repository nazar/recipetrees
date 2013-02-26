class RecipeIngredientRevision < ActiveRecord::Base

  belongs_to :recipe, :class_name => 'RecipeRevision'
#  belongs_to :measure
#  belongs_to :recipe

  belongs_to :recipe_item, :polymorphic => true


  acts_as_revision

  before_create :reassociate_with_recipe, :if => :recipe_in_revision?

  private

   def reassociate_with_recipe
     prev = self.current_revision.recipe.find_revision(:previous)
     self.recipe = prev
   end


   def recipe_in_revision?
     !self.current_revision.recipe.nil? && self.current_revision.recipe.revisable_number > 0
   end


#  def name
#    unless recipe_item_id.blank?
#      case recipe_item_type
#        when "Ingredient"; recipe_item.name
#        when "Recipe"; recipe_item.name
#      end
#    end
#  end


end