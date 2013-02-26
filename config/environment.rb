# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'redcloth'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  config.load_paths += ["#{RAILS_ROOT}/app/sweepers", "#{RAILS_ROOT}/app/achievements",
                        "#{RAILS_ROOT}/app/mixins/models", "#{RAILS_ROOT}/app/observers"]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'ruby-graphviz', :version => '0.9.20', :lib => 'graphviz'
  config.gem 'koala', :version => '1.0.0.beta'
  config.gem 'json', :version => '1.5.1'
  config.gem 'smurf'
  config.gem 'ruby-hmac', :lib => 'hmac'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.active_record.observers = :recipes_observer, :site_join_badges_observer, :fork_observer,
                                   :voter_observer, :watcher_observer, :follower_observer,
                                   :blogger_observer, :ingredient_observer, :recipe_by_others_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :domain => "panthersoftware.com",
  }

end
