require 'rails_helper'

module DiabeticToolbox
  RSpec.describe MembersController, type: :controller do
    #region Settings
    routes { DiabeticToolbox::Engine.routes }
    #endregion

    #region Member
    describe 'a member' do
      let(:member) { build(:member) }
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
      end
    end
    #endregion

    #region Visitor
    describe 'a visitor' do
      it 'should have 200 HTTP status for :new' do
        get :new

        expect(response).to have_http_status 200
      end

      it 'should POST to :create with appropriate parameters' do
        post :create, member: {first_name: 'Tom', last_name: 'Bosley', username: 'Bozman', email: 'bosley@manifesto.net', password: 'password', password_confirmation: 'password', accepted_tos: true}

        expect(response).to have_http_status 302
        expect(response).to redirect_to setup_path
      end
    end
    #endregion
  end
end
