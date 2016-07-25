require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before do
    @event = assign(:event, FactoryGirl.create(:project).events.build)
    render
  end

  it "contains form to correct url" do
    expect(rendered).to have_selector('form[action="%s"][method="%s"]' % [
      "/projects/#{@event.project_id}/events",
      "post"
    ])
  end
end
