require 'spec_helper'

describe User do
  
  before do
    @site_a = Site.make
    @site_b = Site.make
    @admin = User.make(:is_admin => true)
    @site_admin_a = User.make(:is_site_admin => true, :site => @site_a)
    @user_a = User.make(:is_site_admin => false, :site => @site_a)
    @site_admin_b = User.make(:is_site_admin => true, :site => @site_b)
    @user_b = User.make(:is_site_admin => false, :site => @site_b)
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
  
end
