class RecipeByOthersObserver < ActiveRecord::Observer

  observe RecipeByOthers

  def after_create(other)
    Achievement.transaction do
      OthersByBadge.award_achievements_for(other.user)
      Reputation.process_reputation_for(other)
    end
  end

end