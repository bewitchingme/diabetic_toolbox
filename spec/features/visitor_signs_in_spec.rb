require 'spec_helper'

RSpec.describe 'Visitor Signs In', type: :feature do
  let(:member) { build(:member) }
  it 'should display the username regardless of route on successful login' do
    member.save
    visit sign_in_path

    fill_in 'Email', with: member.email
    fill_in 'Password', with: 'password'

    click_button 'Sign In'

    expect(page).to have_content member.username
  end
end