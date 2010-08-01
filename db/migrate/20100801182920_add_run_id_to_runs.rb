class AddRunIdToRuns < ActiveRecord::Migration
  def self.up
    add_column :runs, :run_id, :integer
    add_index :runs, :run_id, :unique => true
  end

  def self.down
    remove_column :runs, :run_id
  end
end
