require "rails_helper"

RSpec.describe UserProjectsController, type: :routing do
  describe "routes for UserProjects" do
    it "routes to #create via POST" do
      expect(post: "/projects/1/create").
        to route_to("user_projects#create", project_id: "1")
    end

    it "routes to #destroy via DELETE" do
      expect(delete: "/projects/2/destroy").
        to route_to("user_projects#destroy", project_id: "2")
    end
  end
end
