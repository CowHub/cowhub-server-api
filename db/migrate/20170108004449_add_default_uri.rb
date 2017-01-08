class AddDefaultUri < ActiveRecord::Migration[5.0]
  def change
    change_column :profile_images, :image_uri, :string, default: 'temporary'
    change_column :imprints_images, :image_uri, :string, default: 'temporary'
  end
end
