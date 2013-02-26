class Follower < ActiveRecord::Base

  acts_as_activity

  belongs_to :follower, :class_name => 'User', :foreign_key => 'from_user_id'
  belongs_to :following, :class_name => 'User', :foreign_key => 'to_user_id'


  #class methods

  def self.add_follower(from_user, to_user)
    unless from_user.id == to_user.id
      follower = Follower.find_or_initialize_by_from_user_id_and_to_user_id(from_user.id, to_user.id)
      if follower.new_record?
        #save it
        follower.save
        #record activities for both users
        follower.create_action_user_activity('follower', from_user)
        follower.create_action_user_activity('following', to_user)
        #stats
        UserCounter.increment_counter(:following_count, from_user.get_counter.id)
        UserCounter.increment_counter(:followers_count, to_user.get_counter.id)
      end
      follower
    end
  end

end
