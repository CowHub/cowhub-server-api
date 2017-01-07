class AddBiometricImprint < ActiveRecord::Migration[5.0]
  def change
    add_column :cattle, :biometric_imprint, :string
  end
end
