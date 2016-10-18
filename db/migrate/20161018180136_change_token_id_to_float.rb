class ChangeTokenIdToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :token_id, :float
  end
end
