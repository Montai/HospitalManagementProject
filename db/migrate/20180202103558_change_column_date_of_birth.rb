class ChangeColumnDateOfBirth < ActiveRecord::Migration
  def change
  	change_column :users, :date_of_birth, :date
  end
end
