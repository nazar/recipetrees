class CreateReputations < ActiveRecord::Migration
  def self.up
    create_table :reputations do |t|
      t.integer  "user_id", :reputable_id
      t.integer  "reputation",                :default => 0
      t.integer  "total",                     :default => 0
      t.string   "reason",     :limit => 200
      t.string   :reputable_type

      t.timestamps
    end
    add_index :reputations, :user_id
    add_index :reputations, :reputable_id

    add_column :users, :reputation_total, :integer, {:default => 0}
  end

  def self.down
    drop_table :reputations

    remove_column :users, :reputation_total
  end
end
