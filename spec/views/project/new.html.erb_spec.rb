RSpec.describe "projects/new", type: :view do
 let(:project) { FactoryGirl.create(:project) }
 let(:user) { FactoryGirl.create(:user) }
 
   before do
    sign_in user
    assign(:project, project)
    visit('/projects/new')
  end


it "Signing in with correct credentials" do
  
  fill_in('Project title', with: 'TextMate 2')
  fill_in('Project description', with: 'A text-editor for OS X')
  fill_in('Due date', with: '11.11.2018')      

  click_button('Create project')
  expect(page).to have_content('Project has been created.')
end
end
