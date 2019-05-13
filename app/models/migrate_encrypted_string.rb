class MigrateEncryptedString < ActiveRecord::Base
  self.table_name = 'encrypted_strings'

  ## Associations
  belongs_to :data_encrypting_key

  attr_encrypted :value,
                 mode:          :per_attribute_iv_and_salt,
                 key:           Proc.new { |string| string.key_toggle(:value) },
                 insecure_mode: Proc.new { |string| string.is_decrypting?(:value) }

  ## Instance Methods
  def is_decrypting?(attribute)
    encrypted_attributes[attribute][:operation] == :decrypting
  end

  def key_toggle(attribute)
    unless is_decrypting?(attribute)
      self.data_encrypting_key = DataEncryptingKey.primary
    end
    data_encrypting_key.encrypted_key
  end
end
