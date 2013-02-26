class StepRevision < ActiveRecord::Base

  belongs_to :recipe, :class_name => 'RecipeRevision'

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





end