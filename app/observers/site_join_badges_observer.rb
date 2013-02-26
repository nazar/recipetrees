class SiteJoinBadgesObserver < ActiveRecord::Observer

  observe User
  
  def after_create(user)
    SiteJoinBadges.award_achievements_for(user)
  end

end