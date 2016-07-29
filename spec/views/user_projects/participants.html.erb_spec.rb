require "rails_helper"

RSpec.describe "user_projects/participants", type: :view do
  let!(:project) { FactoryGirl.create(:project) }
  let(:manager) { project.user }
  let(:contributors) { 3.times.collect { FactoryGirl.create(:user) } }

  context "when logged as manager" do
    before do
      allow(view).to receive(:current_user) { manager }
      view.define_singleton_method(:policy) do |project|
        ProjectPolicy.new(current_user, project)
      end
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
        to have_link("Add new participant", href: "/projects/#{project.id}/link_contributors")
    end
  end

  context "when logged as manager" do
    before do
      allow(view).to receive(:current_user) { contributors[0] }
      view.define_singleton_method(:policy) do |project|
        ProjectPolicy.new(current_user, project)
      end
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
  end
end
