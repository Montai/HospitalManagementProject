class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.string :slot 
      t.timestamps null: false
    end
  end
end
