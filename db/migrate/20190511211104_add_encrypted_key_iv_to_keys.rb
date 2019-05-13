class AddEncryptedKeyIvToKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :data_encrypting_keys, :encrypted_key_iv, :string
    add_index :data_encrypting_keys, :encrypted_key_iv, unique: true
  end
end
