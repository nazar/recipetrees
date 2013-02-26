class ParsersController < ApplicationController

  before_filter :login_required

  def preview
    render :text => params[:data].to_redcloth
  end

end
