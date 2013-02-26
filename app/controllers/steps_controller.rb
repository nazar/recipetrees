class StepsController < ApplicationController

  def image
    @step = Step.find_by_id params[:id]
    unless @step.blank?
      respond_to do |format|
        format.html {
          @page_title = "#{@step.recipe.name} - step #{@step.step_no}"
          render :layout => 'for_images'
        }
        format.js {
          render :inline => "<div class='step_thumbnail'><%= image_tag @step.image.url(:original), :alt => '#{@page_title}' %></div>"
        }
      end
    else
      render :nothing => true
    end
  end

end
