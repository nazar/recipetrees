class IngredientSweeper < ActionController::Caching::Sweeper

  observe Ingredient

  def after_create(ingredient)
    expire_fragments(ingredient)
  end

  def after_update(ingredient)
    expire_fragments(ingredient)
  end

  def after_destroy(ingredient)
    expire_fragments(ingredient)
  end


  private

  def expire_fragments(ingredient)
    #ingredient index page
    expire_fragment(:controller => 'ingredients', :action => 'index', :action_suffix => 'alphabet_filter')
  end

end