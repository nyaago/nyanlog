require 'spec_helper'

describe Folder do
  
  before do
    @folder = Folder.make
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
  
#  pending "add some examples to (or delete) #{__FILE__}"
end
