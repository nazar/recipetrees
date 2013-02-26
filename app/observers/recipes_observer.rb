class RecipesObserver < ActiveRecord::Observer

  observe Recipe
  
  def after_save(recipe)
    Achievement.transaction do
      RecipeBadges.award_achievements_for(recipe.user)
    end
  end

  def after_create(recipe)
    Reputation.process_reputation_for(recipe)
  end

end