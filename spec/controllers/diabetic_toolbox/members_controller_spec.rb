require 'rails_helper'

module DiabeticToolbox
  RSpec.describe MembersController, type: :controller do
    routes { DiabeticToolbox::Engine.routes }
    let(:member) { build(:member) }

    describe 'a member' do
      context 'who is authenticated without configured settings' do
        it 'should be redirected to setup_path from :dash' do
          sign_in_member member
          get :dash

          expect(response).to redirect_to setup_path
        end
      end

      context 'who is authenticated with configured settings' do
        it 'should have 200 HTTP status for :dash' do
          setting = build(:setting)
          member.settings << setting
          sign_in_member member

          get :dash

          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
