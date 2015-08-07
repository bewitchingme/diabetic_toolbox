module DiabeticToolbox::Concerns::Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :password, :password_confirmation

    validates :password, length: (8..64), confirmation: true, presence: true, on: :create
    validates :password, length: (8..64), confirmation: true, on: :update, if: :setting_password?

    def password=(password_str)
      warn 'Password method called.'
      @password               = password_str
      self.encryption_salt    = BCrypt::Engine.generate_salt 12
      self.encrypted_password = BCrypt::Engine.hash_secret(password_str, encryption_salt)
    end

    def authenticate(password)
      password.present? && encrypted_password.present? && encrypted_password == BCrypt::Engine.hash_secret(password, encryption_salt)
    end

    private
      def setting_password?
        self.password || self.password_confirmation
      end
  end

end