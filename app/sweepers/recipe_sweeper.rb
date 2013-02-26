class RecipeSweeper < ActionController::Caching::Sweeper

  observe Recipe

  def after_create(recipe)
    expire_fragments(recipe)
  end

  def after_update(recipe)
    expire_fragments(recipe)
  end

  def after_destroy(recipe)
    expire_fragments(recipe)
  end


  private

  def expire_fragments(recipe)
    #recipe index page
    expire_fragment(:controller => 'recipes', :action => 'index', :action_suffix => 'cuisines')
    expire_fragment(:controller => 'recipes', :action => 'index', :action_suffix => 'tags')
    expire_fragment(:controller => 'recipes', :action => 'index', :action_suffix => 'categories')
    #feed index page
    expire_fragment(:controller => 'feed', :action => 'index', :action_suffix => 'tags')
  end

end
