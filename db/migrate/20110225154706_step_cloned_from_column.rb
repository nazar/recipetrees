class StepClonedFromColumn < ActiveRecord::Migration

  def self.up
    add_column :steps, :cloned_from_id, :integer
    add_index :steps, :cloned_from_id

    Step.update_all("cloned_from_id = revisable_branched_from_id")
    Step.update_all("revisable_branched_from_id = null")
  end

  def self.down
    remove_column :steps, :cloned_from_id
  end

end
