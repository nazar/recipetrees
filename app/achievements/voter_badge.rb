class VoterBadge < Achievement
  
  level 1, :quota => 1,   :level_name => 'Supporter'
  level 2, :quota => 5,   :level_name => 'Balloter'
  level 3, :quota => 10,  :level_name => 'Promoter'
  level 4, :quota => 20,  :level_name => 'Patron'
  level 5, :quota => 50,  :level_name => 'Partisan'
  level 6, :quota => 100, :level_name => 'Proponent'

  set_thing_to_check { |user| user.ratings.count(1) }

  set_description_string { |count| "rating #{count} #{count.to_i > 1 ? 'recipes' : 'recipe'}" }

  on_rating_achieved do |badge|
    User.track_badge_activity(badge)
    badge.spawn :kill => true do
      User.post_user_achievement_to_app_wall(badge)
    end
  end

  def self.award_achievements_for(user)
    process_count_based_achievement(user)
  end


end