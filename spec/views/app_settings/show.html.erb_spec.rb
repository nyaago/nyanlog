require 'spec_helper'

describe "app_settings/show.html.erb" do
  before(:each) do
    @app_setting = assign(:app_setting, stub_model(AppSetting))
  end

  it "renders attributes in <p>" do
    render
  end
end
