class KeyRotationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: 'key-rotations', retry: 0, unique: :until_executed

  def perform
    key = DataEncryptingKey.generate!
    DataEncryptingKey.mark_primary(key)
    MigrateEncryptedString.find_each do |string|
      value = string.value
      string.update(value: value)
    end
    DataEncryptingKey.non_primary.destroy_all
  end
end
