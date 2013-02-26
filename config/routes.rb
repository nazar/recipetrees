ActionController::Routing::Routes.draw do |map|

  map.root :controller => "pages", :action => 'home'

  map.admin '/admin', :controller => 'admin/admin', :action => 'index'

  map.home '/', :controller => 'pages', :action => 'home'

  #sessions
  map.login             '/login',           :controller => 'session', :action => 'login'
  map.logout            '/logout',          :controller => 'session', :action => 'logout'
  map.register          '/register',        :controller => 'session', :action => 'register'
  map.session_activate  '/session/activate/:token', :controller => 'session', :action => 'activate'
  map.facebook_callback '/facebook/callback/:callback_option', :controller => 'facebook', :action => 'callback'
  map.about_page        '/about',           :controller => 'pages', :action => 'about'
  map.contact_page      '/contact',         :controller => 'pages', :action => 'contact'
  map.feed_page         '/feed',            :controller => 'feed', :action => 'index'

  #profiles
  map.resources :profiles, :member => {:follow => :post}

  #account
  map.resource :account, :member => [:about => :post]


  #recipes
  map.resources :recipes, :member => {:print => :get, :watch => :post, :commented => :post, :image => :get, :delete => :delete},
                          :collection => {:filter => :any} do |recipe|
    recipe.resources :by_others, :controller => 'recipes_by_others', :only => [:index, :new, :delete, :create]
  end
  map.recipes_ajax '/recipes/get/ajax',       :controller => 'recipes', :action => 'get_for_ajax'
  map.post_to_app_wall_recipe '/recipes/:id/to_app_wall', :controller => 'recipes', :action => 'to_app_wall'
  map.recipe_by_other_image '/recipes_by_others/image/:id', :controller => 'recipes_by_others', :action => 'image'

  #branches... not quite a resources... only need new and create
  map.new_branch '/branches/:id/new', :controller => 'branches', :action => 'new'
  map.create_branch '/branches/:id/create', :controller => 'branches', :action => 'create'

  #ingredients
  map.resources :ingredients, :member => {:delete => :get, :commented => :post, :by_category => :get, :filter => :get}, :has_one => :nutrition
  map.ingredients_ajax '/ingredients/get/ajax/:id',       :controller => 'ingredients', :action => 'get_for_ajax'
  map.ingredient_image '/ingredients/get/image/:id',      :controller => 'ingredients', :action => 'image'

  #ingredient relations
  map.remove_ingredient_relation '/relations/remove/:ingredient_relation_id/:ingredient_id', :controller => 'relations', :action => 'remove'
  map.add_ingredient_relation '/relations/add/:ingredient_relation_id/:ingredient_id', :controller => 'relations', :action => 'add'

  #servings lookup
  map.lookup_servings '/nutritions/servings/:id', :controller => 'nutritions', :action => 'servings'

  #steps
  map.step_image '/steps/image/:id', :controller => 'steps', :action => 'image'

  #blogs
  map.resources :blogs

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action'
  map.connect ':controller'

end
