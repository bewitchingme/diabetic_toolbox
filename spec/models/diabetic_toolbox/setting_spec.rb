require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Setting, type: :model do
    #region Definitions
    let(:setting_params) {
      {
        glucometer_measure_type: :mmol,
        intake_measure_type: :carbohydrates,
        intake_ratio: 10.0,
        correction_begins_at: 7.1,
        increments_per: 2.0,
        ll_units_per_day: 20
      }
    }
    #endregion

    #region Stories
    describe 'a setting' do
      it 'should save with appropriate parameters' do
        member = create(:member)

        setting = member.settings.new setting_params

        result = setting.save
        member_with_setting = Member.find member.id

        expect(result).to eq true
        expect(member_with_setting.settings.size).to eq 1
      end

      it 'should not save with inappropriate parameters' do
        member = create(:member)

        params = setting_params
        params[:glucometer_measure_type] = :foo
        params[:intake_measure_type] = :bar
        params[:intake_ratio] = 'Bad Input'

        expect { setting = member.settings.new params }.to raise_error ArgumentError
      end
    end
    #endregion
  end
end
