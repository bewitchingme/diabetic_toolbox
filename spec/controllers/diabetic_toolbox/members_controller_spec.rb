require 'rails_helper'

module DiabeticToolbox
  RSpec.describe MembersController, type: :controller do
    #region Settings
    routes { DiabeticToolbox::Engine.routes }
    #endregion

    #region Member
    describe 'a member' do
      #region Definitions
      let(:member) { build(:member) }
      #endregion

      context 'without configured settings' do
        it 'should be redirected to setup_path from :dash' do
          sign_in_member member
          get :dash

          expect(response).to have_http_status 302
          expect(response).to redirect_to setup_path
        end
      end

      context 'with configured settings' do
        it 'should have 200 HTTP status for :dash' do
          setting = build(:setting)
          member.settings << setting
          sign_in_member member

          get :dash

          expect(response).to have_http_status 200
          expect(assigns(:library)).to eq nil
          expect(assigns(:chart_data)).to eq nil
        end

        it 'should have 200 HTTP status for :edit' do
          sign_in_member member

          get :edit, id: member.slug

          expect(response).to have_http_status 200
          expect(assigns(:member)).to be_a Member
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

        it 'should have 200 HTTP status for :confirm_delete' do
          sign_in_member member

          get :confirm_delete, id: member.slug

          expect(response).to have_http_status 200
        end

        it 'should have 302 HTTP status for :update' do
          sign_in_member member

          put :update, id: member.slug, member: {first_name: 'Doris'}

          updated_member = Member.find member.slug

          expect(response).to have_http_status 302
          expect(response).to redirect_to edit_member_path member
          expect(updated_member.first_name).to eq 'Doris'
        end

        it 'should have 302 HTTP status for :destroy' do
          sign_in_member member

          delete :destroy, id: member.slug

          expect { Member.find member.slug }.to raise_error ActiveRecord::RecordNotFound

          expect(response).to have_http_status 302
          expect(response).to redirect_to root_path
        end
      end
    end
    #endregion

    #region Visitor
    describe 'a visitor' do
      #region Definitions
      let(:member_params) { {first_name: 'Tom', last_name: 'Bosley', username: 'Bozman', email: 'bosley@manifesto.net', password: 'password', password_confirmation: 'password', accepted_tos: true} }
      let(:update_params) { {password: 'password', password_confirmation: 'password', first_name: 'Joo Been', last_name: 'Hacked'} }
      #endregion

      it 'should have 200 HTTP status for :new' do
        get :new

        expect(response).to have_http_status 200
      end

      it 'should POST to :create with appropriate parameters' do
        post :create, member: member_params

        expect(response).to have_http_status 302
        expect(response).to redirect_to setup_path
      end

      it 'should be denied when visiting :dash' do
        expect { get :dash }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when visiting :edit' do
        member = build(:member)
        member.save

        expect { get :edit, id: member.slug }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when trying to update a member' do
        member = build(:member)
        member.save

        expect {
          put :update, id: member.slug, member: update_params
        }.to raise_error CanCan::AccessDenied

        expect {
          patch :update, id: member.slug, member: update_params
        }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when trying to delete a member' do
        member = build(:member)
        member.save

        expect { delete :destroy, id: member.slug }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when visiting :confirm_delete' do
        expect { get :confirm_delete }.to raise_error CanCan::AccessDenied
      end
    end
    #endregion
  end
end
