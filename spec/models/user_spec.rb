require 'spec_helper'

describe User do
  
  before do
    @site_a = Site.make
    @site_b = Site.make
    @admin = User.make(:is_admin => true)
    @site_admin_a = User.make(:is_site_admin => true, :site => @site_a)
    @user_a = User.make(:is_site_admin => false, :site => @site_a)
    @user_a2 = User.make(:is_site_admin => false, :site => @site_a)
    @site_admin_b = User.make(:is_site_admin => true, :site => @site_b)
    @user_b = User.make(:is_site_admin => false, :site => @site_b)
    @folder_a1 = Folder.make(:site => @site_a, :owner => @user_a)
    @folder_a2 = Folder.make(:site => @site_a, :owner => @user_a2)
    @folder_a3 = Folder.make(:site => @site_a)
    @folders_a = [@folder_a1, @folder_a2, @folder_a3]
    @folder_b1 = Folder.make(:site => @site_b)
    @folder_b2 = Folder.make(:site => @site_b)
    @folders_b = [@folder_b1, @folder_b2]
    
    
  end
  
  describe "can manage user" do
    it "returns true if the user is a administrator" do
      @admin.can_manage_user?(@user_a).should == true &&
      @admin.can_manage_user?(@user_b).should == true
    end

    it "returns true if the user is a site administrator" do      
      @site_admin_a.can_manage_user?(@user_a).should == true
    end

    it "returns false if the user not a administrator" do      
      @user_a.can_manage_user?(@site_admin_a).should == false
    end

    it "returns false if the user is a site administrator of the other site" do      
      @site_admin_a.can_manage_user?(@user_b).should == false
    end



  end
  describe "can manage site" do
    it "returns true if the user is a administrator" do
      @admin.can_manage_site?(@site_a).should == true &&
      @admin.can_manage_site?(@site_b).should == true
    end
    
    it "returns true if the user is a site administrator" do      
      @site_admin_a.can_manage_site?(@site_a).should == true
    end

    it "returns false if the user not a administrator" do      
      @user_a.can_manage_site?(@site_a).should == false
    end

    it "returns false if the user is a site administrator of the other site" do      
      @site_admin_a.can_manage_site?(@site_b).should == false
    end
    
    
  end
  
  describe "editable folders" do
    it " admin can edit folders " do
      folders = @admin.editable_folders(@site_a)
      folders.size.should == @folders_a.size
      folders.each do |folder|
        @folders_a.include?(folder) == true
      end
    end

    it " site admin can edit folders " do
      folders = @site_admin_a.editable_folders
      folders.size.should == @folders_a.size
      folders.each do |folder|
        @folders_a.include?(folder) == true
      end
    end


    it " site admin can edit folders " do
      folders = @site_admin_a.editable_folders(@site_a)
      folders.size.should == @folders_a.size
      folders.each do |folder|
        @folders_a.include?(folder) == true
      end
    end

    it " site admin cannot edit folders of the other site " do
      folders = @site_admin_a.editable_folders(@site_b)
      folders.size.should == 0
    end
    
    it " the user can edit the owned folder " do
      folders = @user_a.editable_folders
      folders.each do |folder|
        folder.owner_id.should == @user_a.id
      end
    end


  end
  
end
