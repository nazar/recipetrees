module Achievements
  
  def self.included(base)
    base.class_eval do
      has_many :achievements do
        def include?(achievement, level = nil)
          all.select { |a| a.type.to_s == achievement.to_s and a.level == level }.any?
        end
      end
    end
  end

  def award_achievement(achievement, level = nil, level_name = nil, description = nil)
    unless level.nil?
      level_name  ||= achievement.name_for(level)
      description ||= achievement.description_for(level)
    end
    achievement.create!(:user => self, :level => level, :level_name => level_name, :description => description )
  end
  
  def has_achievement?(achievement, level = nil)
    conditions = {:type => achievement.to_s, :user_id => id}    
    conditions[:level] = level if level
    achievements.first(:conditions => conditions).present?
  end
  
  def get_badges_in_progress(badges)
    badges.collect do |achievement|
      {
        :type => achievement,
        :level => achievement.next_level(self),
        :progress => achievement.progress_to_next_level(self),
        :next_level_quota => achievement.next_level_quota(self),
        :current_progress => achievement.current_progress(self),
        :next_level => achievement.next_level(self)
      }
    end.sort_by { |achievement| achievement[:progress] }.reverse[0,3]
  end
  
end