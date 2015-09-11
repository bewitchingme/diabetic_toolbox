require "rails_helper"

module DiabeticToolbox
  from :members, require: %w(recover_member_password)

  RSpec.describe RecoveryKitMailer, type: :mailer do
    #region ActionMailer Configuration
    before(:each) do
      ActionMailer::Base.delivery_method    = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries         = []

      @member = build(:member)
      @member.reset_password_token   = RecoverMemberPassword.create_token
      @member.reset_password_sent_at = Time.now
      @member.save

      RecoveryKitMailer.send_forgot_password_kit(@member).deliver_now
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end
    #endregion

    #region Tests
    describe 'a visitor trying to recover their account' do
      it 'should receive an email with a recovery kit' do
        ActionMailer::Base.deliveries.count.should == 1
      end

      it 'will receive an email at the account email address' do
        ActionMailer::Base.deliveries.first.to.should == [@member.email]
      end

      it 'should receive an email from the appropriate email address' do
        ActionMailer::Base.deliveries.first.from.should == [DiabeticToolbox.mailer_from_address]
      end
    end
    #endregion
  end
end
