class CreateImage < ActiveRecord::Migration[5.0]
  def change
    create_table :image do |t|
      t.references :cattle, index: true, foreign_key: true
      t.string :image_uri
    end
  end
end
