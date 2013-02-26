class UserFacebookId < ActiveRecord::Migration

  def self.up
    add_column :users, :facebook_id, :bigint
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    #
    add_index :users, :facebook_id
  end

  def self.down
    remove_column :users, :facebook_id
    remove_column :users, :first_name
    remove_column :users, :last_name
  end

end
