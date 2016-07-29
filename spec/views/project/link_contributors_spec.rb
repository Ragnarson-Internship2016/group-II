require 'rails_helper'

RSpec.describe "projects/link_contributors", type: :view do
  let(:project) { FactoryGirl.create(:project) }
  let(:manager) { project.user }

  before do
    allow(view).to receive(:current_user) { manager }
    view.define_singleton_method(:policy) do |project|
      ProjectPolicy.new(current_user, project)
    end
    assign(:project, project)
    render
  end

  it "renders Add user to the project header" do
    expect(rendered).to include("Add user to the project:")
  end

  it "renders form" do
    expect(rendered).to have_selector("form")
  end

  it "renders search field" do
    expect(rendered).to have_field("name")
  end
end
