require 'rails_helper'

module DiabeticToolbox
  RSpec.describe SettingsController, type: :controller do
    #region Settings & Definitions
    routes { DiabeticToolbox::Engine.routes }
    let(:setting_params) { {glucometer_measure_type: :mmol, intake_measure_type: :carbohydrates, intake_ratio: 10, correction_begins_at: 7.1, increments_per: 2.0, ll_units_per_day: 18} }
    #endregion

    #region Member
    describe 'a member' do
      #region Member Definitions
      let(:member) { build(:member) }
      let(:setting) { build(:setting) }
      #endregion

      context 'without configured settings' do
        it 'should not be able to GET :edit' do
          sign_in_member member

          get :edit

          expect(response).to have_http_status 302
          expect(response).to redirect_to setup_path
        end

        it 'should be able to GET :new' do
          sign_in_member member

          get :new

          expect(response).to have_http_status 200
        end

        it 'should be able to POST to :create' do
          sign_in_member member

          post :create, setting: setting_params

          expect(response).to have_http_status 302
          expect(response).to redirect_to member_dashboard_path
        end
      end

      context 'with configured settings' do
        it 'should be redirected from :new to :edit' do
          member.settings << setting
          member.save
          sign_in_member member

          get :new

          expect(response).to have_http_status 302
          expect(response).to redirect_to settings_path
        end

        it 'should be able to PUT to :update' do
          member.settings << setting
          member.save
          sign_in_member member

          put :update, setting: setting_params

          last = member.settings.last

          expect(response).to have_http_status 302
          expect(response).to redirect_to settings_path
          expect(member.settings.size).to eq 2
          expect(last.glucometer_measure_type).to eq :mmol.to_s
          expect(last.intake_ratio).to eq 10.0
        end
      end
    end
    #endregion

    #region Visitor
    describe 'a visitor' do
      it 'should be denied when visiting :new' do
        expect { get :new }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when visiting :edit' do
        expect { get :edit }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when trying to PUT to :update' do
        expect { put :update, setting: setting_params }.to raise_error CanCan::AccessDenied
      end

      it 'should be denied when trying to POST to :create' do
        expect { post :create, setting: setting_params }.to raise_error CanCan::AccessDenied
      end
    end
    #endregion
  end
end
