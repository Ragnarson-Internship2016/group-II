require "rails_helper"

RSpec.describe "user_projects/participants", type: :view do
  let!(:project) { FactoryGirl.create(:project) }
  let(:manager) { project.user }
  let(:contributors) { 3.times.collect { FactoryGirl.create(:user) } }
  before do
    assign(:project, project)
    assign(:manager, manager)
    assign(:contributors, contributors)
    render
  end

  it "renders project manager" do
    expect(rendered).to include("#{manager.name} #{manager.surname}")
  end

  it "renders project contributors" do
    expect(rendered).to include("#{contributors[0].name} #{contributors[0].surname}")
    expect(rendered).to include("#{contributors[1].name} #{contributors[1].surname}")
    expect(rendered).to include("#{contributors[2].name} #{contributors[2].surname}")
  end

  it "renders back link to project" do
    expect(rendered).
      to have_link("Back", href: "/projects/#{project.id}")
  end
end
