class ChangeDefaultValueForMatch < ActiveRecord::Migration[5.0]
  def change
    change_column_default :matches, :value, Float::INFINITY
  end
end
