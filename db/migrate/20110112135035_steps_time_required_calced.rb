class StepsTimeRequiredCalced < ActiveRecord::Migration

  def self.up
    change_column :steps, :time_required, :string
    add_column :steps, :time_required_seconds, :integer
  end

  def self.down
    change_column :steps, :time_required, :float
    remove_column :steps, :time_required_seconds
  end

end
