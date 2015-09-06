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
    end
    #endregion
  end
end
