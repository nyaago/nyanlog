require 'spec_helper'

describe "app_settings/index.html.erb" do
  before(:each) do
    assign(:app_settings, [
      stub_model(AppSetting),
      stub_model(AppSetting)
    ])
  end

  it "renders a list of app_settings" do
    render
  end
end
