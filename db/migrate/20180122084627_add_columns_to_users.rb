class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :string, :string
    add_column :users, :date_of_birth, :datetime
    add_column :users, :role, :integer
  end
end
