class CreateVerficationImages < ActiveRecord::Migration[5.0]
  def change
    create_table :verification_images do |t|
      t.references :cattle, foreign_key: true
      t.string :image_uri
      t.timestamps
    end
  end
end
