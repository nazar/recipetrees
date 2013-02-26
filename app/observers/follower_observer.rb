class FollowerObserver < ActiveRecord::Observer

  observe Follower
  
  def after_create(follower)
    Achievement.transaction do
      FolloweeBadge.award_achievements_for(follower.following)
    end
  end

end