class RecipeWatcher < ActiveRecord::Base

  belongs_to :recipe
  belongs_to :user


  #class methods

  def self.add_watcher(recipe, user)
    unless recipe.created_by_id == user.id
      #ensure we don't store duplicates
      watcher = RecipeWatcher.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user.id)
      #increment recipe watcher counter
      if watcher.new_record?
        Recipe.increment_counter(:watchers_count, recipe.id)
        watcher.save
      end
    end
  end

end
