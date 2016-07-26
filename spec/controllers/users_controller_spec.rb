require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET #dashboard" do
    before do
      sign_in(user)

      get :dashboard
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns dashboard template" do
      expect(response).to render_template(:dashboard)
    end
  end
end
