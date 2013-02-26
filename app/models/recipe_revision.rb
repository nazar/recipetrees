class RecipeRevision < ActiveRecord::Base

#  has_many :recipe_ingredients, :class_name => 'RecipeIngredientRevision', :foreign_key => 'recipe_id'
#  has_many :steps, :order => 'step asc', :class_name => 'StepRevision', :foreign_key => 'recipe_id'



  acts_as_revision


end