class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :user, foreign_key: true
      t.references :cattle, foreign_key: true
      t.string :image_uri
      t.integer :status, default: 'pending'
      t.timestamps
    end
  end
end
