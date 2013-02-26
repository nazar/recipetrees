class ForkObserver < ActiveRecord::Observer

  observe RecipeFork
  
  def after_create(recipe_fork)
    Achievement.transaction do
      ForkBadges.award_achievements_for(recipe_fork.forker)
    end
  end

end