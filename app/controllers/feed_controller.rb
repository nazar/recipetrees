class FeedController < ApplicationController

  def index
    @page_title = 'Recipe Trees Feed'
    @actions = Activity.recent.paginate :include => [:item, :user], :page => params[:page]
    @tags = Recipe.tag_counts
  end

  def rss
    @actions = Activity.recent.of_item_types('Recipe','Blog').all :include => [:item, :user], :limit => 30
     render :layout => false
     response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

end
