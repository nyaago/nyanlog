require 'spec_helper'

describe "app_settings/edit.html.erb" do
  before(:each) do
    @app_setting = assign(:app_setting, stub_model(AppSetting))
  end

  it "renders the edit app_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => app_settings_path(@app_setting), :method => "post" do
    end
  end
end
