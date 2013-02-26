class RatingsController < ApplicationController

  def vote
    rating = params[:rate].to_i
    result = {:votes => 0, :avg => 0}
    if rating > 0
      rateable = Rating.find_rateable(params[:rateable_type], params[:rateable_id])
      unless rateable.blank?
        result = {:votes => rateable.ratings_count, :avg => rateable.average_rating}
        unless Rating.already_voted(rateable, request.remote_ip, current_user)
          Rating.transaction do
            rate = Rating.new( :rating => rating,
                        :ip => request.remote_ip,
                        :user_id => current_user.blank? ? 0 : current_user.id )
            rateable.add_rating rate
            rateable.save_with_validation(false)  #bypass validtions as only updating counters here
            #activities
            rateable.create_action_user_activity('rated', current_user) unless current_user.blank?
            #
            result[:votes] = rateable.ratings_count
            result[:avg] = rateable.average_rating
          end
        end
      end
    end
    render :text => result.to_json
  end

end
