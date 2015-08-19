require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Member, type: :model do
    #region Definitions
    let(:member_params) { {first_name: 'Frodo', last_name: 'Baggins',
        email: 'frodo.baggins@example.com', username: 'Ring Bearer',
        password: 'password', password_confirmation: 'password'} }
    let(:create_success_message) { 'Member Frodo Created' }
    let(:create_failure_message) { 'Create Member Failed' }
    let(:safe_model_data) { { first_name: 'Frodo', last_name: 'Baggins', username: 'Ring Bearer', slug: 'ring-bearer' } }
    let(:validations_password_empty) { { password: ['Required', 'Between 8 and 64 characters'] } }
    let(:validations_password_length) { { password: ['Between 8 and 64 characters'] } }
    let(:validations_password_mismatch) { { password_confirmation: ['Passwords must match'] } }
    let(:validations_first_name_format) { { first_name: ['Only letters and spaces allowed'] } }
    let(:validations_last_name_format) { { last_name: ['Only letters and hyphens allowed'] } }
    let(:validations_username_format) { { username: ['Only letters, spaces and numbers allowed'] } }
    #endregion

    #region Stories
    describe 'a member being created' do
      context 'using action class' do
        #region Success Conditions
        it 'should save with appropriate parameters' do
          create_member = Members::CreateMember.new(member_params).call

          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.successful?).to eq true
          expect(create_member.actual.authenticate!(member_params[:password])).to eq true
          expect(create_member.response).to eq [create_success_message, {}, safe_model_data]
        end
        #endregion

        #region Password
        it 'should not save without a password' do
          params = member_params
          params.delete(:password)
          params.delete(:password_confirmation)

          create_member = Members::CreateMember.new(params).call

          expect(create_member.successful?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.actual.errors.messages.size).to be >= 1
          expect(create_member.response).to eq [create_failure_message, validations_password_empty, safe_model_data]
        end

        it 'should not save with a password that is too short' do
          params = member_params
          params[:password] = 'fred'
          params[:password_confirmation] = 'fred'
          short = Members::CreateMember.new(params).call


          expect(short.successful?).to eq false
          expect(short.actual.slug).to eq safe_model_data[:slug]
          expect(short.actual.new_record?).to eq true
          expect(short.actual.errors.messages.size).to be >= 1
          expect(short.response).to eq [ create_failure_message, validations_password_length, safe_model_data ]
        end

        it 'should not save with a password that is too long' do
          params = member_params
          pass   = Faker::Internet.password 65
          params[:password] = params[:password_confirmation] = pass
          long = Members::CreateMember.new(params).call

          expect(long.successful?).to eq false
          expect(long.actual.slug).to eq safe_model_data[:slug]
          expect(long.actual.new_record?).to eq true
          expect(long.actual.errors.messages.size).to be >= 1
          expect(long.response).to eq [ create_failure_message, validations_password_length, safe_model_data ]
        end

        it 'should not save unless passwords match' do
          params = member_params
          params[:password_confirmation] = 'password1'

          create_member = Members::CreateMember.new(params).call

          expect(create_member.successful?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.actual.errors.messages.size).to be >= 1
          expect(create_member.response).to eq [ create_failure_message, validations_password_mismatch, safe_model_data ]
        end
        #endregion

        #region Name First/Last
        it 'should not save with invalid first name' do
          expected = safe_model_data
          params   = member_params

          params[:first_name]   = 'Frodo 959'
          expected[:first_name] = 'Frodo 959'

          create_member = Members::CreateMember.new(params).call

          expect(create_member.successful?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response[1].size).to be >= 1
          expect(create_member.response).to eq [ create_failure_message, validations_first_name_format, expected ]
        end

        it 'should not save with invalid last name' do
          expected = safe_model_data
          params   = member_params

          params[:last_name]   = 'Baggins 88'
          expected[:last_name] = 'Baggins 88'

          create_member = Members::CreateMember.new(params).call

          expect(create_member.successful?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response[1].size).to be >= 1
          expect(create_member.response).to eq [ create_failure_message, validations_last_name_format, expected ]
        end
        #endregion

        #region Username
        it 'should not save with invalid username' do
          expected = safe_model_data
          params   = member_params

          params[:username]   = '!!Ring Bearer'
          expected[:username] = '!!Ring Bearer'
          expected[:slug]     = safe_model_data[:slug]

          create_member = Members::CreateMember.new(params).call

          expect(create_member.successful?).to eq false
          expect(create_member.actual.slug).to eq expected[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response[1].size).to be >= 1
          expect(create_member.response).to eq [ create_failure_message, validations_username_format, expected ]
        end
        #endregion
      end
    end#describe creation

    describe 'a member being updated' do
      context 'using action class' do
        #region Success Conditions
        #endregion

        #region Password
        #endregion

        #region Name First/Last
        #endregion

        #region Username
        #endregion
      end
    end

    describe 'a member being authenticated' do
      context 'using session class' do
        #region Success Conditions
        #endregion

        #region Failure Conditions
        #endregion

        #region Warden Checks
        #endregion

        #region Tracking Checks
        #endregion
      end
    end

    describe 'a member being destroyed' do
      context 'using action class' do
        #region SuccessConditions
        #endregion

        #region Failure Conditions
        #endregion

        #region Warden Checks
        #endregion
      end
    end
    #endregion
  end#describe Member
end
