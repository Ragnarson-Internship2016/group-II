require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  describe "GET user_assigned" do
    it "has a 200 status code" do
      get :show
      expect(response.status).to eq(200)
    end
  end
end
