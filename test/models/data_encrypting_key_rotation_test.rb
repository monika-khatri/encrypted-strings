require 'test_helper'

class DataEncryptingKeyRotationTest < ActiveSupport::TestCase

  def setup
    Sidekiq::Testing.disable!
    Sidekiq.redis(&:flushdb)
  end

  def after_teardown
    Sidekiq::Worker.clear_all
    Sidekiq.redis(&:flushdb)
    super
  end

  test "no job queued" do
    rotation = DataEncryptingKeyRotation.new
    assert_nil rotation.job_id
    assert_nil rotation.status
    assert_equal rotation.status_message, 'No key rotation queued or in progress'
  end

  test "when job is queued" do
    job_id = KeyRotationWorker.perform_async
    rotation = DataEncryptingKeyRotation.new
    assert_equal rotation.job_id, job_id
    assert_equal rotation.status, :queued
    assert_equal rotation.status_message, 'Key rotation has been queued'
  end
end
