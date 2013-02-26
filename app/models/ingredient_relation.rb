class IngredientRelation < ActiveRecord::Base

  belongs_to :user
  belongs_to :relation, :class_name => 'User'


  #class methods

  def self.link_ingredients(ingredient_id, links_to_id)
    # only add if ingredients not already linked
    linked_ids = Ingredient.related_ingredient_ids_to_a(Ingredient.find_by_id(ingredient_id))
    if not linked_ids.include?(links_to_id.to_i)
      IngredientRelation.create(:ingredient_id => ingredient_id, :relation_id => links_to_id)
    end
  end

end
