require 'spec_helper'

describe PageDesign do

  before do
    @site = Site.make
    @folder = Folder.make(:site => @site)
  end

  describe "upload " do
  
    it " jpg" do
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.header_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end

      page_design.should be_valid
      page_design.save!(:validate => true)

      page_design.reload
      page_design.header_image.should_not be_nil
      page_design.save!(:validate => true)
      page_design.reload
      File.exist?(page_design.header_image.path).should == true
    end
  end
end
