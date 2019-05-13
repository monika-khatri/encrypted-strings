require 'test_helper'

class MigrateEncryptedStringTest < ActiveSupport::TestCase

  def setup
    DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
    @old_primary = DataEncryptingKey.primary
    @string = 'example'
    @encrypted_string = EncryptedString.create(value: "example")
    @new_primary = DataEncryptingKey.generate!
    DataEncryptingKey.mark_primary(@new_primary)
  end

  test "decryption" do
    assert_equal @encrypted_string.data_encrypting_key, @old_primary
    assert_equal @encrypted_string.value, @string
  end

  test "re-encryption" do
    migrated_string = MigrateEncryptedString.find(@encrypted_string.id)
    migrated_string.update(value: @string)
    assert_equal migrated_string.data_encrypting_key, DataEncryptingKey.primary
  end
end
