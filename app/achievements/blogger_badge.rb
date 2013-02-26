class BloggerBadge < Achievement

  level 1, :quota => 1,   :level_name => 'Blogger'
  level 2, :quota => 5,   :level_name => 'Announcer'
  level 3, :quota => 10,  :level_name => 'Columnist'
  level 4, :quota => 20,  :level_name => 'Reporter'
  level 5, :quota => 50,  :level_name => 'Journalist'
  level 6, :quota => 100, :level_name => 'Wordsmith'

  set_thing_to_check { |user| user.blogs.count(1) }

  set_description_string { |count| "having #{count} #{count.to_i > 1 ? 'blogs' : 'blog'}" }

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