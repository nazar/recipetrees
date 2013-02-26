class Admin::MeasuresController < Admin::AdminController

  active_scaffold :measures do |config|
    config.label = "Measures"
    update_columns = [:name, :ratio, :description]
    config.list.columns = [:name, :ratio, :description, :created_at, :updated_at]
    config.update.columns = update_columns
    config.create.columns = update_columns
  end


  def index
    @page_title = 'Measures'
    list
  end

end
