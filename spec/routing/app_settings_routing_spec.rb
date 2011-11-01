require "spec_helper"

describe AppSettingsController do
  describe "routing" do

    it "routes to #index" do
      get("/app_settings").should route_to("app_settings#index")
    end

    it "routes to #new" do
      get("/app_settings/new").should route_to("app_settings#new")
    end

    it "routes to #show" do
      get("/app_settings/1").should route_to("app_settings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/app_settings/1/edit").should route_to("app_settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/app_settings").should route_to("app_settings#create")
    end

    it "routes to #update" do
      put("/app_settings/1").should route_to("app_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/app_settings/1").should route_to("app_settings#destroy", :id => "1")
    end

  end
end
