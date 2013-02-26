class Admin::CookingMethodsController < Admin::AdminController

  active_scaffold :cooking_methods do |config|
    config.label = "Cooking methods"
    update_columns = [:name, :description]
    config.list.columns = [:name, :description, :created_at, :updated_at]
    config.create.columns = update_columns
    config.update.columns = update_columns
  end

end
