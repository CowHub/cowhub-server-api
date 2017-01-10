class AddStoredToMatch < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :stored, :boolean
    remove_column :matches, :status
  end
end
