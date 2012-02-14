require 'spec_helper'

describe Image do
  before do
    @site = Site.make
    @folder = Folder.make(:site => @site)
  end

  describe "upload " do
  
    it " jpg" do
      image = Image.new(:folder => @folder, :title => "title")
      begin
        image.image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end

      image.should be_valid
      image.save!(:validate => true)

      image.reload
      image.image.should_not be_nil
      image.title = "image title"
      image.save!(:validate => true)
      image.reload
      File.exist?(image.image.path).should == true
    end
  end

end
