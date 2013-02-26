class VotesGoodRecipe < Achievement

  level 1, :quota => 1,   :level_name => 'Person Pleaser'
  level 2, :quota => 5,   :level_name => 'Crowd Pleaser'
  level 3, :quota => 10,  :level_name => 'Hit'
  level 4, :quota => 20,  :level_name => 'Delicious'
  level 5, :quota => 50,  :level_name => 'Ambrosial'
  level 6, :quota => 100, :level_name => 'Legendary'

  set_thing_to_check { |user| Recipe.by_user(user).good_recipes.count(1) }

  set_description_string { |count| "receiving #{count} good recipe #{count.to_i > 1 ? 'ratings' : 'rating'}" }

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