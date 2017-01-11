class AddDefaultStoredToMatch < ActiveRecord::Migration[5.0]
  def change
    change_column_null :matches, :stored, false, false
    change_column_default :matches, :stored, false
  end
end
