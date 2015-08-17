require 'rails_helper'

module DiabeticToolbox
  RSpec.describe WelcomeController, type: :controller do
    #region Definitions
    routes { DiabeticToolbox::Engine.routes }
    #endregion

    #region Static Routes
    describe 'GET root_path' do
      context 'as defined by route /' do
        it 'responds with 200 status' do
          get :start

          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'GET about_path' do
      context 'as defined by route /about' do
        it 'responds with 200 status' do
          get :about

          expect(response).to have_http_status(200)
        end
      end
    end
    #endregion
  end
end
