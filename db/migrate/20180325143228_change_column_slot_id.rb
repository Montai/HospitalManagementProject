class ChangeColumnSlotId < ActiveRecord::Migration
  def change
  	change_column :appointments, :slot_id, :string
  end
end
