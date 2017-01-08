class RemoveCattleFromMatch < ActiveRecord::Migration[5.0]
  def change
    remove_reference :matches, :cattle
  end
end
