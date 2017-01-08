class AddFieldsToCattle < ActiveRecord::Migration[5.0]
  def change
    change_column :cattle, :breed, 'integer USING CAST(breed AS integer)'
    change_column :cattle, :gender, 'integer USING CAST(gender AS integer)'
    add_column :cattle, :genetic_dam, :string
    add_column :cattle, :surrogate_dam, :string
    add_column :cattle, :sir_dam, :string
    add_column :cattle, :latitude, :float
    add_column :cattle, :longitude, :float
  end
end
