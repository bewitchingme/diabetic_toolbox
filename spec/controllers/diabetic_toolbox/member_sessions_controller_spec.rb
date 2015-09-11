require 'rails_helper'

module DiabeticToolbox
  RSpec.describe MemberSessionsController, type: :controller do
    #region Settings & Definitions
    routes { DiabeticToolbox::Engine.routes }
    let(:member) { build(:member) }
    let(:setting) { build(:setting) }
    #endregion

    #region Visitor
    describe 'a visitor' do
      it 'should be able to GET :new' do
        get :new

        expect(response).to have_http_status 200
      end

      it 'should be denied when trying to DELETE :destroy' do
        expect { delete :destroy }.to raise_error CanCan::AccessDenied
      end

      it 'should be able to GET :password_recovery' do
        get :password_recovery

        expect(response).to have_http_status 200
      end

      it 'should be redirected to root_path when posting to :send_recovery_kit' do
        member.save
        post :send_recovery_kit, member: {email: member.email}

        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end

      it 'should be able to GET :recover with token' do
        DiabeticToolbox.from :members, require: %w(recover_member_password)
        member.reset_password_token   = RecoverMemberPassword.create_token
        member.reset_password_sent_at = Time.now
        member.save

        get :recover, token: member.reset_password_token

        expect(response).to have_http_status 200
      end

      it 'should be able to POST :release with token' do
        DiabeticToolbox.from :members, require: %w(recover_member_password)
        member.reset_password_token   = RecoverMemberPassword.create_token
        member.reset_password_sent_at = Time.now
        member.save

        post :release, token: member.reset_password_token, member: {password: 'password', password_confirmation: 'password'}
        updated_member = Member.find member.id

        expect(updated_member.reset_password_token).to eq nil
        expect(updated_member.reset_password_sent_at).to eq nil
        expect(response).to have_http_status 302
        expect(response).to redirect_to sign_in_path
      end
    end
    #endregion

    #region Member
    describe 'a member' do
      context 'who is authenticated and has no configured settings' do
        it 'should be redirected to the setup when trying to GET :new' do
          sign_in_member member

          get :new

          expect(response).to have_http_status 302
          expect(response).to redirect_to setup_path
        end

        it 'should be able to DELETE to :destroy' do
          sign_in_member member

          delete :destroy

          expect(response).to have_http_status 302
          expect(response).to redirect_to root_path
        end
      end

      context 'who is authenticated' do
        it 'should be redirected to sign_in_path from :reconfirm' do
          DiabeticToolbox.from :members, require: ['change_member_email']

          member.save

          change_params = {
              unconfirmed_email:              'unconfirmed@example.com',
              unconfirmed_email_confirmation: 'unconfirmed@example.com'
          }

          result = ChangeMemberEmail.new( member.id, change_params ).call

          sign_in_member member

          updated_member = Member.find member.id

          get :reconfirm, token: updated_member.confirmation_token

          expect(result.success?).to eq true
          expect(response).to have_http_status 302
          expect(response).to redirect_to sign_in_path
        end

        it 'should have 200 HTTP status for :edit_email' do
          sign_in_member member

          get :edit_email

          expect(response).to have_http_status 200
          expect(assigns(:member)).to be_a Member
        end

        it 'should have 302 HTTP status for :update_email' do
          sign_in_member member

          put :update_email, member: {unconfirmed_email: 'test@example.com', unconfirmed_email_confirmation: 'test@example.com'}
          updated_member = Member.find member.slug

          expect(response).to have_http_status 302
          expect(response).to redirect_to edit_member_path member
          expect(updated_member.unconfirmed_email).to eq 'test@example.com'
        end
      end
    end
    #endregion
  end
end
