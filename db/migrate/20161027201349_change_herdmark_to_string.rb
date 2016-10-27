class ChangeHerdmarkToString < ActiveRecord::Migration[5.0]
  def change
    change_column :cattle, :herdmark, :string
  end
end
