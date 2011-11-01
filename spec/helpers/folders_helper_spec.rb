require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the FolderHelper. For example:
#
# describe FolderHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe FoldersHelper do
  
  def params()
    @params ||= {}
  end
  
  before  do 
    @site = Site.make
    @folder = Folder.make(:site => @site)
  end
  
  describe "folder path" do
    
    it "should return the path for update action when edit action requested " + 
      "(A site is specified as an option.)" do
      params[:action] = 'edit'
      folder_path(@folder, :site => @site).should == "/#{@site.name}/folders/#{@folder.name}"
    end

    it "should return the path for update action when update action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'update'
      folder_path(@folder, :site => @site).should == "/#{@site.name}/folders/#{@folder.name}"
    end

    it "should return the path for create action when new action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'new'
      new_folder = Folder.new(:site => @site)
      folder_path(new_folder, :site => @site).should == 
                  "/#{@site.name}/folders"
    end

    it "should return the path for create action when create action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'create'
      new_folder = Folder.new(:site => @site)
      folder_path(new_folder, :site => @site).should == 
                  "/#{@site.name}/folders"
    end

    it "should return the path for update action when edit action requested" do
      params[:action] = 'edit'
      params[:site] = @site.name
      folder_path(@folder).should == "/#{@site.name}/folders/#{@folder.name}"
    end

    it "should return the path for update action when edit action requested." +
      "(optional parameter is included)." do
      params[:action] = 'edit'
      params[:site] = @site.name
      params[:page] = '2'
      folder_path(@folder, url_options_from_params).should == "/#{@site.name}/folders/#{@folder.name}?page=2"
    end


    it "should return the path for update action when update action requested" do
      params[:action] = 'update'
      params[:site] = @site.name
      folder_path(@folder).should == "/#{@site.name}/folders/#{@folder.name}"
    end

    it "should return the path for create action when new action requested" do
      params[:action] = 'new'
      params[:site] = @site.name
      new_folder = Folder.new(:site => @site, :name => 'new_folder_2')
      folder_path(new_folder).should == 
                  "/#{@site.name}/folders"
    end

    it "should return the path for create action when create action requested" do
      params[:action] = 'create'
      new_folder = Folder.new(:site => @site, :name => 'new_folder_2')
      folder_path(new_folder, :site => @site).should == 
                  "/#{@site.name}/folders"
    end


  end
  
  describe "edit folder path" do
    
    it "should return the path for edit action " + 
      "(A site is specified as an option.)" do
      edit_folder_path(@folder, :site => @site).should == "/#{@site.name}/folders/#{@folder.name}/edit"
    end

    it "should return the path for edit action " do
      params[:site] = @site.name
      edit_folder_path(@folder).should == "/#{@site.name}/folders/#{@folder.name}/edit"
    end

    it "should return the path for edit action (optional parameter is included) " do
      params[:site] = @site.name
      params[:page] = '2'
      edit_folder_path(@folder,url_options_from_params).should == 
          "/#{@site.name}/folders/#{@folder.name}/edit?page=2"
    end
  
  end

  describe "new folder path" do
    
    it "should return the path for new action " + 
      "(A site is specified as an option.)" do
      new_folder_path(:site => @site).should == "/#{@site.name}/folders/new"
    end

    it "should return the path for new action " do
      params[:site] = @site.name
      new_folder_path.should == "/#{@site.name}/folders/new"
    end

    it "should return the path for new action (optional parameter is included)" do
      params[:site] = @site.name
      params[:page] = '2'
      new_folder_path(url_options_from_params).should == "/#{@site.name}/folders/new?page=2"
    end
  
  
  end


  describe "folders path" do
    
    it "should return the path for  index action " + 
      "(A site is specified as an option.)" do
      folders_path(:site => @site).should == "/#{@site.name}"
    end

    it "should return the path for index action " do
      params[:site] = @site.name
      folders_path.should == "/#{@site.name}"
    end

    it "should return the path for index action (optional parameter is included)" do
      params[:site] = @site.name
      params[:page] = '2'
      folders_path(url_options_from_params).should == "/#{@site.name}?page=2"
    end

    it "should return the path for list action " + 
      "(A site is specified as an option.)" do
      folders_path(:site => @site, :action => :list).should == "/#{@site.name}/folders/list"
    end

    it "should return the path for list action " do
      params[:site] = @site.name
      folders_path(:action => :list).should == "/#{@site.name}/folders/list"
    end
  
  end
  
end
