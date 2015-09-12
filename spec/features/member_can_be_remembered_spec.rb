require 'rails_helper'

RSpec.feature 'Member Can Be Remembered', type: :feature do
  #region Definitions
  let(:member) { create(:member) }
  #endregion

  #region Tests
  scenario 'a member choosing to be remembered will be' do
    sign_in_and_choose_to_be_remembered
    expire_cookies

    remembrance_token = get_me_the_cookie('remembrance_token')

    visit member_dashboard_path

    ['Measurement Systems', 'Treatment Values'].each do |chunk|
      expect(page).to have_text chunk
    end
    expect(remembrance_token[:value]).to eq member.remembrance_token
  end
  #endregion

  #region Private
  private
  def sign_in_and_choose_to_be_remembered
    visit sign_in_path

    fill_in 'Email',    with: member.email
    fill_in 'Password', with: 'password'
    check 'Remember me in the future'

    click_button 'Sign In'
    member.reload
  end

  #endregion
end