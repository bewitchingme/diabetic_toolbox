require 'rails_helper'

RSpec.feature "Account Is Locked After Max Failed Attempts", type: :feature do
  #region Definitions
  let(:member)  { create(:member) }
  #endregion

  #region Tests
  it 'should display locked response after three bad attempts' do
    DiabeticToolbox.max_attempts.times do
      sign_in_without_correct_password
    end

    expect(page).to have_text 'Account Locked'
  end
  #endregion

  #region Private
  private
  def sign_in_without_correct_password
    visit sign_in_path

    fill_in 'Email',    with: member.email
    fill_in 'Password', with: 'password1'

    click_button 'Sign In'
  end
  #endregion
end
