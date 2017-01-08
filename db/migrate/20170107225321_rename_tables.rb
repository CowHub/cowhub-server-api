class RenameTables < ActiveRecord::Migration[5.0]
  def change
    rename_table :biometric_imprint, :profile_images
    rename_table :images, :imprints_images
  end
end
