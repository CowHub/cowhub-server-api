class CreateCattleTable < ActiveRecord::Migration
  def change
    create_table :cattle do |t|
      t.string :country_code
      t.integer :herdmark
      t.integer :check_digit
      t.integer :individual_number
      t.string :name
      t.string :breed
      t.string :gender
      t.date :dob
    end
  end
end
