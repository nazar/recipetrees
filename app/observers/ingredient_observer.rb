class IngredientObserver < ActiveRecord::Observer

  observe Ingredient

  def after_save(ingredient)
    #don't add reputation for repeated ingredient edits
    if not ingredient.previously_revised_by_same_user
      Ingredient.transaction do
        Reputation.process_reputation_for(ingredient)
      end
    end
  end

end