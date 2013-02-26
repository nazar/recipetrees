class Admin::CuisinesController < Admin::AdminController

  active_scaffold :cuisines do |config|
    config.label = "Cuisines"
    update_columns = [:name, :description]
    config.list.columns = [:name, :description, :created_at, :updated_at]
    config.create.columns = update_columns
    config.update.columns = update_columns
  end


end
