class RemoveColumnsFromUser < ActiveRecord::Migration
  def change
  	remove_column :appointments, :starting_time
  	remove_column :appointments, :ending_time
  end
end
