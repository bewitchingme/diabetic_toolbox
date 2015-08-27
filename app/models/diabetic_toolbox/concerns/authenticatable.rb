module DiabeticToolbox::Concerns::Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :password, :password_confirmation

    validates :email, presence: { message: I18n.t('activerecord.validations.common.required')},
              length: { maximum: 256, message: I18n.t('activerecord.validations.common.maximum', maximum: 256) },
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('activerecord.validations.common.authenticatable.email_format')},
              uniqueness: { message: I18n.t('activerecord.validations.common.authenticatable.email_uniqueness') }
    validates :password, on: :create, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (8..64), message: I18n.t('activerecord.validations.common.length_range', min: 8, max: 64) },
              confirmation: { message: I18n.t('activerecord.validations.common.authenticatable.password_confirmation') }
    validates :password, length: { in: (8..64), message: I18n.t('activerecord.validations.common.length_range', min: 8, max: 64) },
              confirmation: { message: I18n.t('activerecord.validations.common.authenticatable.password_confirmation') },
              if: :setting_password?, on: :update

    def password=(password_str)
      @password               = password_str
      if @password.present? && @password.length > 0
        self.encryption_salt    = BCrypt::Engine.generate_salt 12
        self.encrypted_password = BCrypt::Engine.hash_secret(password_str, encryption_salt)
      end
    end

    def authenticate!(password)
      return true if authenticate password
      raise "Authentication Failure For: #{email}"
    end

    def authenticate(password)
      password.present? && encrypted_password.present? && encrypted_password == BCrypt::Engine.hash_secret(password, encryption_salt)
    end

    private
      def setting_password?
        self.password.present? || self.password_confirmation.present?
      end
  end

end