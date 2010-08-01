class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.float :distance
      t.float :avg_pace

      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
