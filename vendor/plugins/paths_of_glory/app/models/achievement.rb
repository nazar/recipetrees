class Achievement < ActiveRecord::Base

  belongs_to :user
  
  named_scope :not_notified, :conditions => {:notified => false}
  named_scope :recent, :order => "created_at desc"
  named_scope :kind_of, lambda { |type| {:conditions => {:type => type.to_s}}} do
    def current
      order("level desc").limit(1).first
    end
  end
  
  named_scope :order, lambda { |order| {:order => order} }
  named_scope :limit, lambda { |limit| {:limit => limit} }

  class << self
    def levels
      @levels ||= []
    end

    def level(level, options = {})
      levels << {:level => level, :quota => options[:quota], :level_name => options[:level_name]}
    end
    
    def set_thing_to_check(&block)
      @thing_to_check = block
    end
    
    def thing_to_check(object)
      @thing_to_check.call(object)
    end

    def set_description_string(&block)
      @badge_description = block
    end

    def on_rating_achieved(&block)
      @rating_achieved_callback = block
    end

    def do_rating_achieved(badge)
      @rating_achieved_callback.call(badge) unless @rating_achieved_callback.nil?
    end

    def description_string(count)
      @badge_description.call(count)
    end
    
    def select_level(level)
      levels.select { |l| l[:level] == level }.first
    end
    
    def quota_for(level)
      select_level(level)[:quota] if select_level(level)
    end

    def name_for(level)
      select_level(level)[:level_name] if select_level(level)
    end

    def description_for(level)
      description_string quota_for(level)
    end
    
    def has_level?(level)
      select_level(level).present?
    end
    
    def current_level(user)
      if current_achievement = user.achievements.kind_of(self).current
        current_achievement.level
      else
        0
      end
    end
    
    def next_level(user)
      current_level(user) + 1
    end
    
    def current_progress(user)
      thing_to_check(user) - quota_for(current_level(user)).to_i
    end
    
    def next_level_quota(user)
      quota_for(next_level(user)) - quota_for(current_level(user)).to_i
    end
    
    def progress_to_next_level(user)
      if(has_level?(next_level(user)))
        return [(current_progress(user) * 100) / next_level_quota(user), 95].min
      else
        return nil
      end
    end

    def process_count_based_achievement(user)
      return unless user
      count = thing_to_check(user)
      current = current_level(user)
      levels.each do |level|
        break if count < level[:quota]
        next if level[:level].to_i < current
        if (not user.has_achievement?(self, level[:level])) and count >= level[:quota]
           do_rating_achieved user.award_achievement(self, level[:level])
        end
      end
    end

  end
end
