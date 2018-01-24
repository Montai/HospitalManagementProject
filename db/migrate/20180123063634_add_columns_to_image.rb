class AddColumnsToImage < ActiveRecord::Migration
  def change
    add_column :images, :imagable_id, :integer
    add_column :images, :imagable_type, :string
    add_column :images, :image, :string
  end
end
