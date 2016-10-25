class CreateBiometricImprint < ActiveRecord::Migration[5.0]
  def change
    create_table :biometric_imprints do |t|
      t.references :cattle, index: true, foreign_key: true
      t.string :imprint
    end
  end
end
