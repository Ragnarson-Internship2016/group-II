require 'rails_helper'

RSpec.describe "projects/new", type: :view do
   let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end

  it "contains form to correct url" do
    expect(rendered).to have_selector('form[action="%s"][method="%s"]' % [
      "/projects",
      "post"
    ])
  end
end

context 'Creating Projects' do
    it "can create a project" do
      visit ('/projects/new')
      #click_link 'New Project'
      fill_in 'Title', with: 'TextMate 2'
      fill_in 'Description', with: 'A text-editor for OS X'
      click_button 'Create Project'
      #expect(page).to have_content('Project has been created.')
    end
  end
end