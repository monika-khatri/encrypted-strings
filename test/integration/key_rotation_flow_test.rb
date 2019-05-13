require 'test_helper'

class KeyRotationFlowTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  def setup
    Sidekiq.redis(&:flushdb)
    DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
    # Currently we have one test case needing bulk data, in future, we can use FactoryBot.
    1100.times { |index| EncryptedString.create(value: "example-#{index}") }
  end

  def after_teardown
    Sidekiq::Worker.clear_all
    Sidekiq.redis(&:flushdb)
    super
  end

  def test_key_rotation_create
    Sidekiq::Testing.inline! do
      @old_primary = DataEncryptingKey.primary
      post data_encrypting_keys_rotate_path
      assert_response :success
      refute_equal DataEncryptingKey.primary, @old_primary
      assert_equal DataEncryptingKey.count, 1
      distinct_keys = EncryptedString.distinct.pluck(:data_encrypting_key_id)
      assert_equal distinct_keys.length, 1
      assert_equal DataEncryptingKey.find(distinct_keys.first), DataEncryptingKey.primary
    end
  end
end
