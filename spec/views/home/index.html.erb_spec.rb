require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  before do
    render
  end

  it "has img tag with browser vector" do
    expect(rendered).to have_css("img.landing-browser[src*='/assets/browser']")
  end

  it "has h1 slogan with proper class" do
    expect(rendered).to have_css("h1.landing-slogan")
  end

  it "has 'Get started' link to sign up" do
    expect(rendered).to have_link("Get started", href: "/users/sign_up")
  end
end
