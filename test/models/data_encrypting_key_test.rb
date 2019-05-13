require 'test_helper'

class DataEncryptingKeyTest < ActiveSupport::TestCase

  def setup
    DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
  end

  test "invalid without key" do
    key = DataEncryptingKey.new
    refute key.valid?
    assert_not_nil key.errors[:key]
  end

  test ".generate!" do
    assert_difference "DataEncryptingKey.count" do
      key = DataEncryptingKey.generate!
      assert key
    end
  end

  test ".rotation" do
    rotation = DataEncryptingKey.rotation
    assert_instance_of DataEncryptingKeyRotation, rotation
  end

  test ".mark_primary" do
    new_key = DataEncryptingKey.generate!
    DataEncryptingKey.mark_primary(new_key)
    assert new_key.primary
    assert_equal DataEncryptingKey.where(primary: true).count, 1
  end
end
