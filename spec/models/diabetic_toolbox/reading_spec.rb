require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Reading, type: :model do
    #region Definitions
    let(:reading) { build(:reading) }
    let(:member)  { build(:member)  }
    #endregion

    #region Stories
    describe 'a member' do
      context 'recording a new reading' do
        #region Success
        DiabeticToolbox.from :readings, require: %w(create_member_reading)
        it 'should save with appropriate parameters' do
          member.save

          params = {
            glucometer_value: reading.glucometer_value,
            test_time: reading.test_time,
            meal: reading.meal,
            intake: reading.intake
          }

          result = CreateMemberReading.new( member, params ).call
          member.reload

          expect(result.success?).to eq true
          expect(result.flash).to eq 'Your reading was successfully recorded'
          expect(member.readings.size).to eq 1
        end
        #endregion

        #region Failure
        it 'should not save without required parameters' do
          member.save

          params = {}

          result = CreateMemberReading.new( member, params ).call
          member.reload

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, your reading could not be recorded'
          expect(member.readings.size).to eq 0
        end
        #endregion
      end
    end
    #endregion
  end
end
