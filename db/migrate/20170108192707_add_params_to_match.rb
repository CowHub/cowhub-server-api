class AddParamsToMatch < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :value, :float, default: -1
    add_column :matches, :count, :integer, default: -1
    add_column :matches, :results, :integer, default: 0
    add_reference :matches, :imprint_image, foreign_key: true
  end
end
