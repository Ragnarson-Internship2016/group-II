require 'rails_helper'

RSpec.describe "events/index", type: :view do
  let(:project) { FactoryGirl.create(:project) }
  let(:events) do
    3.times.collect { FactoryGirl.create(:event, project: project) }
  end
  before do
    assign(:events, events)
    assign(:project, project)
    allow(view).to receive(:current_user) { events[0].author }
    view.define_singleton_method(:policy) do |event2|
      EventPolicy.new(current_user, event2)
    end
    render
  end

  it "renders events titles" do
    expect(rendered).to include(events[0].title)
    expect(rendered).to include(events[1].title)
    expect(rendered).to include(events[2].title)
  end

  it "does not render link to edit non-authored event" do
    expect(rendered).not_to have_link(
      "Edit", href: "/projects/#{project.id}/events/#{events[1].id}/edit"
    )
  end

  it "does not render link to destroy non-authored" do
    expect(rendered).not_to have_link(
      "Destroy", href: "/projects/#{project.id}/events/#{events[1].id}"
    )
  end

  it "renders link to new event page" do
    expect(rendered).to have_link(
      nil, href: "/projects/#{project.id}/events/new"
    )
  end

  it "renders link to project" do
    expect(rendered).to have_link(
      "Back", href: "/projects/#{project.id}"
    )
  end
end
