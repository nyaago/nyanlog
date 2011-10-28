require 'spec_helper'

describe Article do

  before do
    @folder = Folder.make
    @article = Article.make(:folder => @folder)
    @article2 = Article.make(:folder => @folder)
    @article3 = Article.make(:folder => @folder)
  end
  
  describe 'opened_at' do
    it "valid opened at should be receiced" do
      @article.attributes = { :opened_year => '2011', :opened_month => '10', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @article.valid?.should == true
    end
    
    it "invalid opened date should be not received" do
      @article.attributes = { :opened_year => '', :opened_month => '10', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @article.valid?.should == false
    end
    
    it "invalid opened month should be not received" do
      @article.attributes = { :opened_year => '2011', :opened_month => '13', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @article.valid?.should == false
    end
    
    it "invalid opened day should be not received" do
      @article.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '30', 
                              :opened_hour => '10', :opened_min => '30'}
      @article.valid?.should == false
    end

    it "invalid opened hour should be not received" do
      @article.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '25', 
                              :opened_hour => '25', :opened_min => '30'}
      @article.valid?.should == false
    end

    it "invalid opened minute should be not receiced" do
      @article.attributes = { :opened_year => '2011', :opened_month => '2', :opened_day => '25', 
                              :opened_hour => '20', :opened_min => '65'}
      @article.valid?.should == false
    end

    it "Set opened_at should be valid value" do
      tm = Time.new(2011,5,10,10,30)
      @article.attributes = { :opened_year => tm.year, :opened_month => tm.month, :opened_day => tm.day, 
                              :opened_hour => tm.hour, :opened_min => tm.min}
      @article.opened_at.should == tm &&
      @article.opened_year.should == tm.year  &&
      @article.opened_month.should == tm.month  &&
      @article.opened_year.day == tm.day  &&
      @article.opened_hour.should == tm.hour  &&
      @article.opened_min.should == tm.min 
    end

    
  end


  describe 'closed_at' do
    it "valid closed at should be receiced" do
      @article.attributes = { :closed_year => '2011', :closed_month => '10', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @article.valid?.should == true
    end

    it "invalid closed date should be not received" do
      @article.attributes = { :closed_year => '', :closed_month => '10', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @article.valid?.should == false
    end

    it "invalid closed month should be not received" do
      @article.attributes = { :closed_year => '2011', :closed_month => '13', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @article.valid?.should == false
    end

    it "invalid closed day should be not received" do
      @article.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '30', 
                              :closed_hour => '10', :closed_min => '30'}
      @article.valid?.should == false
    end

    it "invalid closed hour should be not received" do
      @article.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '25', 
                              :closed_hour => '25', :closed_min => '30'}
      @article.valid?.should == false
    end

    it "invalid closed minute should be not receiced" do
      @article.attributes = { :closed_year => '2011', :closed_month => '2', :closed_day => '25', 
                              :closed_hour => '20', :closed_min => '65'}
      @article.valid?.should == false
    end
    
    it "Set closed_at should be valid value" do
      tm = Time.new(2011,5,10,10,30)
      @article.attributes = { :closed_year => tm.year, :closed_month => tm.month, :closed_day => tm.day, 
                              :closed_hour => tm.hour, :closed_min => tm.min}
      @article.closed_at.should == tm &&
      @article.closed_year.should == tm.year  &&
      @article.closed_month.should == tm.month  &&
      @article.closed_year.day == tm.day  &&
      @article.closed_hour.should == tm.hour  &&
      @article.closed_min.should == tm.min 
    end

  end
  
  describe 'ordering' do
    
    it "order by created desc" do
      exp = Regexp.new("order\s+by.+created_at\s+desc", true)
      @folder.ordering_type = Folder::ORDERING_BY_CREATED_AT_DESC
      @folder.articles.listing(@folder).to_sql.should match(exp)
    end
    
    it "order by updated desc" do
      exp = Regexp.new("order\s+by.+updated_at\s+desc", true)
      @folder.ordering_type = Folder::ORDERING_BY_UPDATED_AT_DESC
      @folder.articles.listing(@folder).to_sql.should match(exp)
    end
    
    it "order by created asc" do
      exp = Regexp.new("order\s+by.+created_at\s+asc", true)
      @folder.ordering_type = Folder::ORDERING_BY_CREATED_AT_ASC
      @folder.articles.listing(@folder).to_sql.should match(exp)
    end
    
    it "order by updated asc" do
      exp = Regexp.new("order\s+by.+updated_at\s+asc", true)
      @folder.ordering_type = Folder::ORDERING_BY_UPDATED_AT_ASC
      @folder.articles.listing(@folder).to_sql.should match(exp)
    end
    
    it "order by specifying" do
      exp = Regexp.new("order\s+by.+order_of_display", true)
      @folder.ordering_type = Folder::ORDERING_SPECIFYING
      @folder.articles.listing(@folder).to_sql.should match(exp)
    end
    
    
  end

end
