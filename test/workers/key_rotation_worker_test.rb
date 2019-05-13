require 'test_helper'

class KeyRotationWorkerTest < Minitest::Test

  def setup
    Sidekiq.redis(&:flushdb)
    DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
    @encrypted_string = EncryptedString.create(value: "example")
  end

  def after_teardown
    Sidekiq::Worker.clear_all
    Sidekiq.redis(&:flushdb)
    super
  end

  def test_perform
    Sidekiq::Testing.inline! do
      @old_primary = DataEncryptingKey.primary
      KeyRotationWorker.perform_async
      refute_equal DataEncryptingKey.primary, @old_primary
      assert_equal DataEncryptingKey.count, 1
    end
  end
end
