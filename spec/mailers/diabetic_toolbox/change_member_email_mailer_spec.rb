require "rails_helper"

module DiabeticToolbox
  from :members, require: %w(change_member_email)

  RSpec.describe ChangeMemberEmailMailer, type: :mailer do
    #region ActionMailer Configuration
    before(:each) do
      ActionMailer::Base.delivery_method    = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries         = []

      @member = build(:member)
      @member.unconfirmed_email    = 'test@example.com'
      @member.confirmation_token   = ChangeMemberEmail.create_token
      @member.confirmation_sent_at = Time.now
      @member.save

      ChangeMemberEmailMailer.send_confirmation_link(@member).deliver_now
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end
    #endregion

    #region Tests
    describe 'a member changing their email' do
      it 'should receive an email with a reconfirmation link' do
        ActionMailer::Base.deliveries.count.should == 1
      end

      it 'should be the recipient of the reconfirmation email' do
        ActionMailer::Base.deliveries.first.to.should == [@member.unconfirmed_email]
      end

      it 'should receive an email from the appropriate email address' do
        ActionMailer::Base.deliveries.first.from.should == [DiabeticToolbox.mailer_from_address]
      end
    end
    #endregion
  end
end
