class SiteJoinBadges < Achievement
  
  def self.award_achievements_for(user)
     return unless user
     return if user.has_achievement?(self)
     user.award_achievement(self, nil, 'Associate', 'joining Recipe Trees')
  end
  
end