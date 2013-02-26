class WatcherObserver < ActiveRecord::Observer

  observe RecipeWatcher
  
  def after_create(recipe_watcher)
    Achievement.transaction do
      WatcherBadge.award_achievements_for(recipe_watcher.user)
    end
  end

end