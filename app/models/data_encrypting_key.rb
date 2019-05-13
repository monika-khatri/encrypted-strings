class DataEncryptingKey < ActiveRecord::Base

  attr_encrypted :key,
                 key: :key_encrypting_key

  ## Validations
  validates :key, presence: true

  ## Scopes
  scope :non_primary, -> { where(primary: false) }
  scope :primaries, -> { where(primary: true) }

  ## Class methods
  class << self

    def primary
      find_by(primary: true)
    end

    def rotation
      DataEncryptingKeyRotation.new
    end

    def generate!(attrs={})
      create!(attrs.merge(key: AES.key))
    end

    def mark_primary(key)
      primaries.where.not(id: key.id).update_all(primary: false)
      key.update(primary: true)
    end
  end

  ## Instance methods
  def key_encrypting_key
    ENV['KEY_ENCRYPTING_KEY']
  end
end
