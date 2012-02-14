require 'spec_helper'

describe Folder do
  
  before do
    @site = Site.make
    @site2 = Site.make
    @admin = User.make(:is_admin => true)
    @site_admin = User.make(:is_site_admin => true, :site => @site)
    @site2_admin = User.make(:is_site_admin => true, :site => @site2)
    @editor = User.make(:is_site_admin => true, :site => @site)
    @user = User.make(:site => @site2)
    @owner = User.make(:site => @site)
    
    @folder = Folder.make(:site => @site, :owner => @owner)
  end
  
  describe 'opened_at' do
    it "valid opened at should be receiced" do
      @folder.attributes = { :opened_year => '2011', :opened_month => '10', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @folder.valid?.should == true
    end
    
    it "invalid opened date should be not received" do
      @folder.attributes = { :opened_year => '', :opened_month => '10', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @folder.valid?.should == false
    end
    
    it "invalid opened month should be not received" do
      @folder.attributes = { :opened_year => '2011', :opened_month => '13', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @folder.valid?.should == false
    end
    
    it "invalid opened day should be not received" do
      @folder.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid opened hour should be not received" do
      @folder.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '25', 
                              :opened_hour => '25', :opened_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid opened minute should be not receiced" do
      @folder.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '25', 
                              :opened_hour => '20', :opened_min => '65'}
      @folder.valid?.should == false
    end

    it "Set opened_at should be valid value" do
      tm = Time.new(2011,5,10,10,30)
      @folder.attributes = { :opened_year => tm.year, :opened_month => tm.month, :opened_day => tm.day, 
                              :opened_hour => tm.hour, :opened_min => tm.min}
      @folder.opened_at.should == tm &&
      @folder.opened_year.should == tm.year  &&
      @folder.opened_month.should == tm.month  &&
      @folder.opened_year.day == tm.day  &&
      @folder.opened_hour.should == tm.hour  &&
      @folder.opened_min.should == tm.min 
    end

    
  end


  describe 'closed_at' do
    it "valid closed at should be receiced" do
      @folder.attributes = { :closed_year => '2011', :closed_month => '10', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @folder.valid?.should == true
    end

    it "invalid closed date should be not received" do
      @folder.attributes = { :closed_year => '', :closed_month => '10', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid closed month should be not received" do
      @folder.attributes = { :closed_year => '2011', :closed_month => '13', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid closed day should be not received" do
      @folder.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid closed hour should be not received" do
      @folder.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '25', 
                              :closed_hour => '25', :closed_min => '30'}
      @folder.valid?.should == false
    end

    it "invalid closed minute should be not receiced" do
      @folder.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '25', 
                              :closed_hour => '20', :closed_min => '65'}
      @folder.valid?.should == false
    end
    
    it "Set closed_at should be valid value" do
      tm = Time.new(2011,5,10,10,30)
      @folder.attributes = { :closed_year => tm.year, :closed_month => tm.month, :closed_day => tm.day, 
                              :closed_hour => tm.hour, :closed_min => tm.min}
      @folder.closed_at.should == tm &&
      @folder.closed_year.should == tm.year  &&
      @folder.closed_month.should == tm.month  &&
      @folder.closed_year.day == tm.day  &&
      @folder.closed_hour.should == tm.hour  &&
      @folder.closed_min.should == tm.min 
    end
    
  end
  
  describe 'ordering type' do
    
    it "should  receive valid value" do
      @folder.ordering_type = Folder::ORDERING_BY_CREATED_AT_DESC
      @folder.valid?.should == true
    end
    
    it "should not blank" do
      @folder.ordering_type = ''
      @folder.valid?.should == false
    end

    it "should not invalid value" do
      @folder.ordering_type = 'ByCreated'
      @folder.valid?.should == false
    end
    
  end
  
  
  describe 'editable_for' do
    

    it "should only owned" do
      site = Site.make
      user = User.make(:is_admin => false, :is_editor => false, :site => site)
      admin = User.make(:is_admin => true, :is_editor => false, :site => site)
      editor = User.make(:is_admin => false, :is_editor => true, :site => site)
      folder_count_of_user = 2
      folder_count_of_editor = 2
      folder_count_of_admin = 2
      (1..folder_count_of_user).each do
        Folder.make(:site => site, :owner => user)
      end
      (1..folder_count_of_editor).each do
        Folder.make(:site => site, :owner => editor)
      end
      (1..folder_count_of_admin).each do
        Folder.make(:site => site, :owner => admin)
      end

      Folder.editable_for(user).each do |folder|
        folder.owner_id.should == user.id
      end
      Folder.editable_for(user).count.should == folder_count_of_user
    end

    it "should return  all folders in the site for the admin" do
      site = Site.make
      user = User.make(:is_admin => false, :is_editor => false, :site => site)
      admin = User.make(:is_admin => true, :is_editor => false, :site => site)
      editor = User.make(:is_admin => false, :is_editor => true, :site => site)
      folder_count_of_user = 2
      folder_count_of_editor = 2
      folder_count_of_admin = 2
      (1..folder_count_of_user).each do
        Folder.make(:site => site, :owner => user)
      end
      (1..folder_count_of_editor).each do
        Folder.make(:site => site, :owner => editor)
      end
      (1..folder_count_of_admin).each do
        Folder.make(:site => site, :owner => admin)
      end

      Folder.editable_for(admin).count.should == folder_count_of_user + 
                                                folder_count_of_editor + folder_count_of_admin + 1
    end


    it "should return  all folders in the site for the editor" do
      site = Site.make
      user = User.make(:is_admin => false, :is_editor => false, :site => site)
      admin = User.make(:is_admin => true, :is_editor => false, :site => site)
      editor = User.make(:is_admin => false, :is_editor => true, :site => site)
      folder_count_of_user = 2
      folder_count_of_editor = 2
      folder_count_of_admin = 2
      (1..folder_count_of_user).each do
        Folder.make(:site => site, :owner => user)
      end
      (1..folder_count_of_editor).each do
        Folder.make(:site => site, :owner => editor)
      end
      (1..folder_count_of_admin).each do
        Folder.make(:site => site, :owner => admin)
      end

      Folder.editable_for(editor).count.should == folder_count_of_user + 
                                                folder_count_of_editor + folder_count_of_admin
    end
  
  end
  
  describe "can_manage_for" do
    
    it " the administrator can  manage the folder " do
      Folder.can_manage_for(@admin).include?(@folder).should == true
    end

    it " the site administrator can  manage the folder " do
      Folder.can_manage_for(@site_admin).include?(@folder).should == true
    end

    it " the site administrator at the other site can not  manage the folder " do
      Folder.can_manage_for(@site2_admin).include?(@folder).should == false
    end

    it " the owner can  manage the folder " do
      Folder.can_manage_for(@owner).include?(@folder).should == true
    end

    it " non owner can not manage the folder" do
      Folder.can_manage_for(@user).include?(@folder).should == false
    end
    
  end


  describe "editable_for" do
    
    it " the administrator can  edit the folder " do
      Folder.editable_for(@admin).include?(@folder).should == true
    end

    it " the site administrator can  edit the folder " do
      Folder.editable_for(@site_admin).include?(@folder).should == true
    end

    it " the site administrator at the other site can not  edit the folder " do
      Folder.editable_for(@site2_admin).include?(@folder).should == false
    end

    it " the editor can  edit the folder " do
      Folder.editable_for(@editor).include?(@folder).should == true
    end


    it " the owner can  edit the folder " do
      Folder.editable_for(@owner).include?(@folder).should == true
    end

    it " non owner can not edit the folder" do
      Folder.editable_for(@user).include?(@folder).should == false
    end
    
  end

  
#  pending "add some examples to (or delete) #{__FILE__}"
end
