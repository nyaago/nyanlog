require 'spec_helper'

describe "app_settings/new.html.erb" do
  before(:each) do
    assign(:app_setting, stub_model(AppSetting).as_new_record)
  end

  it "renders new app_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => app_settings_path, :method => "post" do
    end
  end
end
