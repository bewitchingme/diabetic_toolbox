#:enddoc:
module DiabeticToolbox::Concerns::Authenticatable
  extend ActiveSupport::Concern

  included do
    #region Attributes
    attr_accessor :password
    #endregion

    #region Callbacks
    before_save :encrypt_password_if_present
    #endregion

    #region Validations
    validates :email, presence: { message: I18n.t('activerecord.validations.common.required')},
              length: { maximum: 256, message: I18n.t('activerecord.validations.common.maximum', maximum: 256) },
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('activerecord.validations.common.authenticatable.email_format')},
              uniqueness: { message: I18n.t('activerecord.validations.common.authenticatable.email_uniqueness') }
    validates :unconfirmed_email, on: :update, length: { maximum: 256, message: I18n.t('activerecord.validations.common.maximum', maximum: 256) },
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('activerecord.validations.common.authenticatable.email_format')},
              confirmation: { message: I18n.t('activerecord.validations.common.authenticatable.unconfirmed_email_confirmation') }, if: :changing_email?
    validates :unconfirmed_email_confirmation, presence: { message: I18n.t('activerecord.validations.common.required') },
              if: :changing_email?, on: :update
    validates :password, on: :create, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (8..64), message: I18n.t('activerecord.validations.common.length_range', min: 8, max: 64) },
              confirmation: { message: I18n.t('activerecord.validations.common.authenticatable.password_confirmation') }
    validates :password, length: { in: (8..64), message: I18n.t('activerecord.validations.common.length_range', min: 8, max: 64) },
              confirmation: { message: I18n.t('activerecord.validations.common.authenticatable.password_confirmation') },
              if: :setting_password?, on: :update
    validates :password_confirmation, presence: { message: I18n.t('activerecord.validations.common.required') }, if: :setting_password?
    #endregion

    #region Public
    def authenticate(password)
      password.present? && encrypted_password.present? && encrypted_password == BCrypt::Engine.hash_secret(password, encryption_salt)
    end
    #endregion

    #region Private
    private
    def setting_password?
      !self.password.blank?
    end

    def changing_email?
      self.unconfirmed_email_changed?
    end

    def encrypt_password_if_present
      if setting_password?
        self.encryption_salt    = BCrypt::Engine.generate_salt 12
        self.encrypted_password = BCrypt::Engine.hash_secret(self.password, encryption_salt)
      end
    end
    #endregion
  end

end