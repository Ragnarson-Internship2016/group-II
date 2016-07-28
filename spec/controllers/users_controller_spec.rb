require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { project.user }

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

  describe "GET #search" do
    before do
      sign_in(user)

      get :search, format: :js, params: { id: project.id, name: user.name }
    end

    it "returns respons in javascript" do
      expect(response.content_type).to match("text/javascript")
    end

    it "renders search_result template" do
      expect(render_template(template: :_search_result))
    end

    it "finds project" do
      expect(assigns(:project)).to eql(project)
    end

    it "finds user" do
      expect(assigns(:users)).to include(user)
    end
  end
end
