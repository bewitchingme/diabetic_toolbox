require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Member, type: :model do
    #region Definitions
    let(:member_params) { {first_name: 'Frodo', last_name: 'Baggins',
        email: 'frodo.baggins@example.com', username: 'Ring Bearer',
        password: 'password', password_confirmation: 'password',
        accepted_tos: true } }
    let(:create_success_message) { 'Membership for Frodo created' }
    let(:create_failure_message) { 'Membership registration failed' }
    let(:safe_model_data) { { first_name: 'Frodo', last_name: 'Baggins', username: 'Ring Bearer', slug: 'ring-bearer' } }
    let(:unconfirmed_email) { { unconfirmed_email: 'sample@example.com', unconfirmed_email_confirmation: 'sample@example.com'} }
    let(:validations_password_empty) { { password: ['Required', 'Between 8 and 64 characters'] } }
    let(:validations_password_length) { { password: ['Between 8 and 64 characters'] } }
    let(:validations_password_mismatch) { { password_confirmation: ['Passwords must match'] } }
    let(:validations_first_name_format) { { first_name: ['Only letters and spaces allowed'] } }
    let(:validations_last_name_format) { { last_name: ['Only letters and hyphens allowed'] } }
    let(:validations_username_format) { { username: ['Only letters, spaces and numbers allowed'] } }
    let(:validations_email_format) { { email: ['Invalid address'] } }
    let(:validations_accepted_tos_required) { { accepted_tos: ['Required'] } }
    #endregion

    #region Stories
    describe 'a member being created' do
      DiabeticToolbox.from :members, require: %w(create_member)
      context 'using action class' do
        #region Success Conditions
        it 'should save with appropriate parameters' do
          create_member = CreateMember.new(member_params).call

          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.success?).to eq true
          expect(create_member.actual.authenticate(member_params[:password])).to eq true
          expect(create_member.response).to eq [create_success_message, {}, safe_model_data]
        end
        #endregion

        #region Email
        it 'should not save with invalid email address' do
          params = member_params
          params[:email] = 'some_bad_string'

          result = CreateMember.new( params ).call

          expect(result.actual.new_record?).to eq true
          expect(result.success?).to eq false
          expect(result.flash).to eq create_failure_message
          expect(result.response).to eq [create_failure_message, validations_email_format, safe_model_data]
        end
        #endregion

        #region Password
        it 'should not save without a password' do
          params = member_params
          params.delete(:password)
          params.delete(:password_confirmation)

          create_member = CreateMember.new(params).call

          expect(create_member.success?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response).to eq [create_failure_message, validations_password_empty, safe_model_data]
        end

        it 'should not save with a password that is too short' do
          params = member_params
          params[:password] = 'fred'
          params[:password_confirmation] = 'fred'
          short = CreateMember.new(params).call

          expect(short.success?).to eq false
          expect(short.actual.slug).to eq safe_model_data[:slug]
          expect(short.actual.new_record?).to eq true
          expect(short.response).to eq [ create_failure_message, validations_password_length, safe_model_data ]
        end

        it 'should not save with a password that is too long' do
          params = member_params
          pass   = Faker::Internet.password 65
          params[:password] = params[:password_confirmation] = pass
          long = CreateMember.new(params).call

          expect(long.success?).to eq false
          expect(long.actual.slug).to eq safe_model_data[:slug]
          expect(long.actual.new_record?).to eq true
          expect(long.response).to eq [ create_failure_message, validations_password_length, safe_model_data ]
        end

        it 'should not save unless passwords match' do
          params = member_params
          params[:password_confirmation] = 'password1'

          create_member = CreateMember.new(params).call

          expect(create_member.success?).to eq false
          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response).to eq [ create_failure_message, validations_password_mismatch, safe_model_data ]
        end
        #endregion

        #region Name First/Last
        it 'should not save with invalid first name' do
          expected = safe_model_data
          params   = member_params

          params[:first_name]   = 'Frodo 959'
          expected[:first_name] = 'Frodo 959'

          create_member = CreateMember.new(params).call

          expect(create_member.success?).to eq false
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

          create_member = CreateMember.new(params).call

          expect(create_member.success?).to eq false
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

          create_member = CreateMember.new(params).call

          expect(create_member.success?).to eq false
          expect(create_member.actual.slug).to eq expected[:slug]
          expect(create_member.actual.new_record?).to eq true
          expect(create_member.response[1].size).to be >= 1
          expect(create_member.response).to eq [ create_failure_message, validations_username_format, expected ]
        end
        #endregion

        #region TOS
        it 'should not save without acceptance of the terms of service' do
          params = member_params
          params.delete :accepted_tos

          create_member = CreateMember.new(member_params).call

          expect(create_member.actual.slug).to eq safe_model_data[:slug]
          expect(create_member.success?).to eq false
          expect(create_member.response).to eq [create_failure_message, validations_accepted_tos_required, safe_model_data]
        end
        #endregion
      end
    end

    describe 'a member being updated' do
      DiabeticToolbox.from :members, require: %w(update_member)
      context 'using action class' do
        #region Success Conditions
        it 'should update with valid parameters' do
          member = build(:member)
          member.save

          result  = UpdateMember.new( member.id, {first_name: 'Roy', time_zone: 'Eastern Time (US & Canada)'} ).call
          updated = Member.find(member.id)

          expect(result.flash).to eq 'Saved'
          expect(result.response).to eq ['Saved', {}, {first_name: 'Roy', last_name: member.last_name, username: member.username, slug: member.slug}]
          expect(result.actual.first_name).to eq 'Roy'
          expect(result.success?).to eq true
          expect(updated.first_name).to eq 'Roy'
        end
        #endregion

        #region Password
        it 'should not update without confirmation of password if password is present' do
          member = build(:member)
          member.save

          result  = UpdateMember.new( member.id, {password: 'passable'} ).call
          updated = Member.find(member.id)

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq password_confirmation: ['Required']
          expect(result.success?).to eq false
          expect(updated.encrypted_password).to eq member.encrypted_password
        end

        it 'should not update with a password under minimum length' do
          member = build(:member)
          member.save

          result  = UpdateMember.new( member.id, {password: 'fred', password_confirmation: 'fred'} ).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq password: ['Between 8 and 64 characters']
          expect(result.success?).to eq false
          expect(updated.encrypted_password).to eq member.encrypted_password
        end

        it 'should not update with a password over maximum length' do
          member = build(:member)
          member.save
          pass = 'a'
          64.times do
            pass += 'a'
          end

          result  = UpdateMember.new( member.id, {password: pass, password_confirmation: pass} ).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq password: ['Between 8 and 64 characters']
          expect(result.success?).to eq false
          expect(updated.encrypted_password).to eq member.encrypted_password
        end
        #endregion

        #region Name First/Last
        it 'should not update if first name is of invalid format' do
          member = build(:member)
          first  = member.first_name
          member.save

          result  = UpdateMember.new(member.id, {first_name: 'Groyo!1!'}).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq first_name: ['Only letters and spaces allowed']
          expect(result.success?).to eq false
          expect(updated.first_name).to eq first
        end

        it 'should not update if first name is of invalid length' do
          member = build(:member)
          first  = member.first_name
          member.save

          first_to = 'A'

          64.times do
            first_to += 'a'
          end

          result  = UpdateMember.new(member.id, {first_name: first_to} ).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq first_name: ['Between 1 and 64 characters']
          expect(result.success?).to eq false
          expect(updated.first_name).to eq first
        end

        it 'should not update if last name is of invalid format' do
          member = build(:member)
          last   = member.last_name
          member.save

          result  = UpdateMember.new(member.id, {last_name: 'Summer Dog'} ).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq last_name: ['Only letters and hyphens allowed']
          expect(result.success?).to eq false
          expect(updated.last_name).to eq last
        end

        it 'should not update if last name is of invalid length' do
          member = build(:member)
          last   = member.last_name
          member.save

          last_to = 'A'

          64.times do
            last_to += 'a'
          end

          result  = UpdateMember.new(member.id, {last_name: last_to}).call
          updated = Member.find member.id

          expect(result.flash).to eq 'Error: Record Unsaved'
          expect(result.response[1]).to eq last_name: ['Between 1 and 64 characters']
          expect(result.success?).to eq false
          expect(updated.last_name).to eq last
        end
        #endregion
      end
    end

    describe 'a member changing their email' do
      DiabeticToolbox.from :members, require: %w(change_member_email)
      context 'using action class' do
        #region Success Conditions
        it 'should update with email and confirmation' do
          member = create(:member)

          update_params = {
              unconfirmed_email: 'some@example.com',
              unconfirmed_email_confirmation: 'some@example.com'
          }
          safe = {
              first_name: member.first_name,
              last_name: member.last_name,
              username: member.username,
              slug: member.slug
          }
          result  = ChangeMemberEmail.new( member.id, update_params ).call
          updated = Member.find(member.id)

          expect(result.flash).to eq 'Confirmation Sent'
          expect(result.response).to eq ['Confirmation Sent', {}, safe]
          expect(result.success?).to eq true
          expect(result.actual.unconfirmed_email).to eq 'some@example.com'
          expect(updated.unconfirmed_email).to eq 'some@example.com'
          expect(updated.confirmation_token).not_to be_empty
          expect(updated.confirmation_sent_at.utc.to_i).to eq Time.now.utc.to_i
        end
        #endregion

        #region Failure
        it 'should not update with invalid email format with confirmation on update' do
          member = create(:member)

          update_params = {
            unconfirmed_email: 'some_bad_string',
            unconfirmed_email_confirmation: 'some_bad_string'
          }
          safe = {
              first_name: member.first_name,
              last_name: member.last_name,
              username: member.username,
              slug: member.slug
          }

          result  = ChangeMemberEmail.new( member.id, update_params ).call
          updated = Member.find(member.id)

          expect(result.flash).to eq 'Error: Email Unchanged'
          expect(result.response).to eq ['Error: Email Unchanged', {unconfirmed_email: ['Invalid address']}, safe]
          expect(result.success?).to eq false
          expect(updated.unconfirmed_email).to eq member.unconfirmed_email
        end

        it 'should not update with email address without matching confirmation' do
          member = create(:member)

          update_params = {
            unconfirmed_email: 'some@example.com',
            unconfirmed_email_confirmation: 'fruit@example.com'
          }

          result  = ChangeMemberEmail.new( member.id, update_params ).call
          updated = Member.find(member.id)
          safe = {
            first_name: member.first_name,
            last_name: member.last_name,
            username: member.username,
            slug: member.slug
          }

          expect(result.flash).to eq 'Error: Email Unchanged'
          expect(result.response).to eq ['Error: Email Unchanged', {unconfirmed_email_confirmation: ['Emails must match']}, safe]
          expect(result.success?).to eq false
          expect(updated.email).to eq member.email
        end
        #endregion
      end
    end

    describe 'a member reconfirming their email' do
      DiabeticToolbox.from :members, require: %w(change_member_email reconfirm_member)
      context 'using action class' do
        #region Success Conditions
        it 'should successfully perform the exchange with the appropriate token' do
          member = create(:member)

          change_result = ChangeMemberEmail.new( member.id, unconfirmed_email ).call
          member.reload

          reconfirm_result = ReconfirmMember.new( member.confirmation_token ).call
          member.reload

          expect(change_result.success?).to eq true
          expect(reconfirm_result.success?).to eq true
          expect(member.confirmation_token).to eq nil
          expect(member.unconfirmed_email).to eq nil
          expect(member.confirmed_at).not_to eq nil
          expect(member.confirmation_sent_at).to eq nil
          expect(member.email).to eq unconfirmed_email[:unconfirmed_email]
        end
        #endregion

        #region Failure
        it 'should fail when trying to perform the exchange with inappropriate token' do
          reconfirm_result = ReconfirmMember.new( 'bad_token' ).call

          expect(reconfirm_result.success?).to eq false
        end

        it 'should fail when trying to perform the exchange with a nil token' do
          reconfirm_result = ReconfirmMember.new( nil ).call

          expect(reconfirm_result.success?).to eq false
        end
        #endregion
      end
    end

    describe 'a member being destroyed' do
      DiabeticToolbox.from :members, require: %w(destroy_member)
      context 'using action class' do
        #region SuccessConditions
        it 'should be deleted along with all data excepting recipes' do
          member = create(:member)
          member.settings.create glucometer_measure_type: :mmol, intake_measure_type: :carbohydrates
          id_to_delete = member.id
          result = DestroyMember.new(id_to_delete).call

          expect { Member.find(id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { Setting.find(member_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { Reading.find(member_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { Achievement.find(member_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { ReportConfiguration.find(member_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { Report.find(member_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound
          expect { Vote.find(voter_id: id_to_delete) }.to raise_error ActiveRecord::RecordNotFound

          expect(result.success?).to eq true
        end
        #endregion
      end
    end
    #endregion
  end
end
