require 'test_helper'

class EncryptedStringTest < ActiveSupport::TestCase

  def setup
    DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
  end

  test ".encrypted_key" do
    encrypted_string = EncryptedString.create(value: 'Example')
    assert_equal encrypted_string.encrypted_key, DataEncryptingKey.primary.encrypted_key
  end

  test "invalid without value" do
    encrypted_string = EncryptedString.create
    refute encrypted_string.valid?
    assert_not_nil encrypted_string.errors[:value]
  end

  test "before validation set_token" do
    encrypted_string = EncryptedString.new
    encrypted_string.validate
    assert_not_nil encrypted_string.token
  end

  test "before validation set_data_encryption_key" do
    encrypted_string = EncryptedString.new
    encrypted_string.validate
    assert_not_nil encrypted_string.data_encrypting_key
    assert_equal encrypted_string.data_encrypting_key, DataEncryptingKey.primary
  end
end
