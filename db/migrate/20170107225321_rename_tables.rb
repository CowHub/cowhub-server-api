class RenameTables < ActiveRecord::Migration[5.0]
  def change
    rename_table :biometric_imprints, :profile_pictures
    rename_table :images, :biometric_imprints
  end
end
