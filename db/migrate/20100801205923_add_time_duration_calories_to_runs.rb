class AddTimeDurationCaloriesToRuns < ActiveRecord::Migration
  def self.up
    add_column :runs, :start_time, :timestamp
    add_column :runs, :duration, :integer
    add_column :runs, :calories, :integer
  end

  def self.down
    remove_column :runs, :calories
    remove_column :runs, :duration
    remove_column :runs, :start_time
  end
end
