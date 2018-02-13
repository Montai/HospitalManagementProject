class ChangeFieldType < ActiveRecord::Migration
  def change
  	change_column :appointments, :date, :date
  end
end
