class Admin::CategoriesController < Admin::AdminController

  active_scaffold :categories do |config|
    config.label = "Categories List"
    #columns
    editable = [:name, :description, :display_order,  :children, :parent]
    config.list.columns   = [:name, :description, :display_order, :children, :level]
    config.show.columns   = editable
    config.update.columns = editable
    config.create.columns = editable

    config.columns[:parent].form_ui = :select
  end


  protected

  def conditions_for_collection
    'categories.parent_id is null' unless params[:parent_column]
  end

end
