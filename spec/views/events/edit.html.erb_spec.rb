require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before do
    @event = assign(:event, FactoryGirl.create(:event))
    render
  end

  it "contains form to correct url" do
    expect(rendered).to have_selector('form[action="%s"][method="%s"]' % [
      "/projects/#{@event.project_id}/events/#{@event.id}",
      "post"
    ])
  end
end
