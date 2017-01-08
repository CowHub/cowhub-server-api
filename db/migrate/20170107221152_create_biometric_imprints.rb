class CreateBiometricImprints < ActiveRecord::Migration[5.0]
  def change
    create_table :biometric_imprint do |t|
      t.references :cattle, foreign_key: true
      t.string :image_uri

      t.timestamps
    end
  end
end
