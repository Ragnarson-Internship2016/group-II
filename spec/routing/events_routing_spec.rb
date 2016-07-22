require "rails_helper"

RSpec.describe EventsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/projects/1/events").
        to route_to("events#index", project_id: "1")
    end

    it "routes to #new" do
      expect(get: "/projects/2/events/new").
        to route_to("events#new", project_id: "2")
    end

    it "routes to #show" do
      expect(get: "/projects/3/events/1").
        to route_to("events#show", project_id: "3", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/projects/1/events/2/edit").
        to route_to("events#edit", project_id: "1", id: "2")
    end

    it "routes to #create via POST" do
      expect(post: "/projects/2/events").
        to route_to("events#create", project_id: "2")
    end

    it "routes to #update via PUT" do
      expect(put: "/projects/3/events/4").
        to route_to("events#update", project_id: "3", id: "4")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/projects/2/events/8").
        to route_to("events#update", project_id: "2", id: "8")
    end

    it "routes to #destroy via DELETE" do
      expect(delete: "/projects/5/events/1").
        to route_to("events#destroy", project_id: "5", id: "1")
    end
  end
end
