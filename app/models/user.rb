class User < ActiveRecord::Base

  require 'digest/sha1'

  has_many :recipes, :foreign_key => 'created_by_id'
  has_many :blogs

  has_many :followers, :foreign_key => 'from_user_id'
  has_many :i_am_following, :through => :followers, :source => :following
  has_many :inverse_followers, :class_name => 'Follower', :foreign_key => 'to_user_id'
  has_many :following_me, :through => :inverse_followers, :source => :follower
  has_many :forks, :class_name => 'RecipeFork', :foreign_key => 'forked_by_id'
  has_many :ratings
  has_many :ratings_5, :class_name => 'Rating', :conditions => 'ratings.rating = 5'
  has_many :ratings_1, :class_name => 'Rating', :conditions => 'ratings.rating = 1'
  has_many :watching_recipes, :class_name => 'RecipeWatcher'
  has_many :tried_recipes, :class_name => 'RecipeByOthers'

  has_many :reputations, :order => 'reputations.id ASC'


  has_one :counter, :class_name => 'UserCounter'

  has_attached_file :avatar,
                    :styles => { :original => ['180x360>', 'jpg'], :thumbnail => ['50x50#', 'jpg']  },
                    :default_style => :original,
                    :convert_options => { :all => "-strip" },
                    :default_url => "/images/no_:style_avatar.png"

  tracks_unlinked_activities [:joined_the_site, :badge]

  include Achievements


  validates_presence_of     :login, :email, :name
  validates_length_of       :login, :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false

  before_save :create_user_token

  attr_protected :admin, :activated, :active, :token, :email

  named_scope :ids, :select => 'users.id'
  named_scope :activated, :conditions => ['activated = ?', true]
  named_scope :active_members, :conditions => ['activated = ? and active = ?', true, true]
  named_scope :admins, :conditions => {:admin => true}

  TOKENLENGTH = 15


  #class methods

  def self.facebook_register_user_from_graph(facebook_info, request)
    returning(User.find_or_initialize_by_facebook_id(facebook_info['id'])) do |user|
      if user.new_record?
        #all user's must have a unique email... check if user exists with this email
        email_user = User.find_by_email(facebook_info['email'])
        user = email_user unless email_user.blank?
        #
        user.first_name = facebook_info['first_name']
        user.last_name  = facebook_info['last_name']
        user.login      = "#{user.first_name.downcase}.#{user.last_name.downcase}"
        user.name       = facebook_info['name']
        user.email      = facebook_info['email']
        user.bio        = facebook_info['bio']
        user.activate
        user.save
        #send welcome email
        UserMailer.set_home_from_request(request)
        UserMailer.create_welcome_email(user)
        #activity
        user.track_activity(:joined_the_site)
      end
    end
  end

  def self.track_badge_activity(badge)
    badge.user.track_activity_with_extra(:badge, "Achieved <strong>#{badge.level_name}</strong> Badge for #{badge.description}")
  end

  def self.post_user_achievement_to_app_wall(badge)
    user = User.find_by_id(badge.user_id)
    oauth = Koala::Facebook::OAuth.new( '/facebook/callback/connect' )
    graph = Koala::Facebook::GraphAPI.new(oauth.get_app_access_token_info['access_token'])

    message = {'name' => "The #{badge.level_name} Badge",
               :description => "Awarded for #{badge.description}",
               'link' => "http://recipetrees.com/profiles/#{user.to_param}"}
    #
    graph.put_wall_post("#{user.name} achieved the #{badge.level_name} badge.", message, '191116444251564' )
  end

  #instance methods

  def initialise_counters
    create_counter if counter.blank?
  end

  def password_required?
    facebook_id.blank?
  end

  def activate
    self.activated = true
    self.active    = true
  end

  def facebook_profile
    "http://graph.facebook.com/#{facebook_id}/picture?type=large" unless facebook_id.blank?
  end

  def facebook_thumbnail
    "http://graph.facebook.com/#{facebook_id}/picture" unless facebook_id.blank?
  end

  def to_param
    "#{id}_#{login.to_permalink}"
  end

  def get_counter
    if counter.blank?
      create_counter
    else
      counter
    end
  end

  def i_am_following_user_ids
    i_am_following.all(:select => 'users.id').collect{|u| u.id}
  end


  protected

  def validate_email
    begin
      TMail::Address.parse(email)
    rescue
      errors.add(:email, 'Must be a valid email')
    end
  end

  def create_user_token
    return unless token.blank?
    self.token = String.random_string(TOKENLENGTH)
    while not User.find_by_token(self.token).blank?
      self.token = String.random_string(TOKENLENGTH)
    end
  end


end
