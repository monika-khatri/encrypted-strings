class DataEncryptingKeyRotation
  attr_reader :job_id

  def initialize
    @job_id = Sidekiq::Queue.new('key-rotations').first.try(:jid)
  end

  ##
  # @return Symbol|NilClass - status of the key rotation job
  def status
    @status ||= Sidekiq::Status::status(job_id)
  end

  ##
  # @return String - humanized status message of the key rotation job
  def status_message
    if status == :queued
      'Key rotation has been queued'
    elsif status == :working
      'Key rotation is in progress'
    else
      'No key rotation queued or in progress'
    end
  end
end
