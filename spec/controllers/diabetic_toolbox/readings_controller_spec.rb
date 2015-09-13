require 'rails_helper'

module DiabeticToolbox
  RSpec.describe ReadingsController, type: :controller do
    routes { DiabeticToolbox::Engine.routes }
    #region Definitions
    let(:member) { create(:member) }
    let(:reading) { build(:reading) }
    #endregion

    #region Member
    describe 'a member' do
      it 'should be able to GET to :index' do
        sign_in_member member

        get :index

        expect(response).to have_http_status 200
      end

      it 'should be able to GET to :new' do
        sign_in_member member

        get :new

        expect(response).to have_http_status 200
      end

      it 'should be able to POST to :create' do
        sign_in_member member

        reading_params = {
          glucometer_value: reading.glucometer_value,
          test_time: reading.test_time,
          meal: reading.meal,
          intake: reading.intake
        }

        post :create, reading: reading_params
        member.reload
        expect(response).to have_http_status 302
        expect(response).to redirect_to list_readings_path
        expect(member.readings.size).to eq 1
      end
    end
    #endregion

    #region Visitor
    #endregion
  end
end
