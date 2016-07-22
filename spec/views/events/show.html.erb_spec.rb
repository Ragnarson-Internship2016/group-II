require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before do
    @event = assign(:event, FactoryGirl.create(:event))
    allow(view).to receive(:current_user) { current_user }
    view.define_singleton_method(:policy) do |event2|
      EventPolicy.new(current_user, event2)
    end
    render
  end
  let(:current_user) { FactoryGirl.create(:user) }

  it "renders event title" do
    expect(rendered).to include(@event.title)
  end

  it "renders event author surname" do
    expect(rendered).to include(@event.author.surname)
  end

  it "render link to project events page" do
    expect(rendered).
      to have_link("Back", href: "/projects/#{@event.project_id}/events")
  end

  context "when signed in as event author" do
    let(:current_user) { @event.author }

    it "renders link to edit event" do
      expect(rendered).to have_link(
        "Edit",
        href: "/projects/#{@event.project_id}/events/#{@event.id}/edit"
      )
    end
  end

  context "when signed in as non-author" do
    it "does not render link to edit event" do
      expect(rendered).not_to have_link(
        "Edit",
        href: "/projects/#{@event.project_id}/events/#{@event.id}/edit"
      )
    end
  end
end
