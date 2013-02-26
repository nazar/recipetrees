class VotesFiveStar < Achievement
  
  level 1, :quota => 1,   :level_name => 'Fan'
  level 2, :quota => 5,   :level_name => 'Food bon Vivant'
  level 3, :quota => 10,  :level_name => 'Epicure'
  level 4, :quota => 20,  :level_name => 'Connoisseur'
  level 5, :quota => 50,  :level_name => 'Gourmand'
  level 6, :quota => 100, :level_name => 'Gastronomer'

  set_thing_to_check { |user| user.ratings_5.count(1) }

  set_description_string { |count| "rating #{count} #{count.to_i > 1 ? 'recipes' : 'recipe'} 5 out of 5" }

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