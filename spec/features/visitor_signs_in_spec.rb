require 'spec_helper'

RSpec.describe 'Visitor Signs In', type: :feature do
  #region Definitions
  let(:member)  { create(:member) }
  let(:setting) { build(:setting) }
  #endregion

  #region Tests
  it 'should display the username regardless of route on successful login' do
    sign_in

    expect(page).to have_text member.username
  end

  it 'should display setup dialog if no settings have been configured' do
    sign_in

    expect(page).to have_text 'Measurement Systems'
    expect(page).to have_text 'Treatment Values'
  end

  it 'should display dashboard if settings have been configured' do
    member.settings.create glucometer_measure_type: setting.glucometer_measure_type, intake_measure_type: setting.intake_measure_type
    sign_in

    ['Summary', 'Readings', 'Reports', 'Recipes', 'Meal Plans'].each do |chunk|
      expect(page).to have_text chunk
    end
  end
  #endregion

  #region Private
  private
  def sign_in
    visit sign_in_path

    fill_in 'Email',    with: member.email
    fill_in 'Password', with: 'password'

    click_button 'Sign In'
  end
  #endregion
end