require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ArticlesHelper. For example:
#
# describe ArticlesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ArticlesHelper do
  def params()
    @params ||= {}
  end
  
  before  do 
    @site = Site.make
    @folder = Folder.make(:site => @site)
    @article = Article.make(:folder => @folder)
  end
  
  describe "article path" do
    
    it "should return the path for update action when edit action requested " + 
      "(A site is specified as an option.)" do
      params[:action] = 'edit'
      article_path(@article, :site => @site, :folder => @folder).should == 
        "/#{@site.name}/#{@folder.name}/#{@article.id}"
    end

    it "should return the path for update action when update action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'update'
      article_path(@article, :site => @site, :folder => @folder).should == 
        "/#{@site.name}/#{@folder.name}/#{@article.id}"
    end

    it "should return the path for create action when new action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'new'
      new_article = Article.new(:folder => @folder,:title => 'new_article_2')
      article_path(new_article, :site => @site, :folder => @folder).should == 
                  "/#{@site.name}/#{@folder.name}"
    end

    it "should return the path for create action when create action requested" + 
      "(A site is specified as an option.)" do
      params[:action] = 'create'
      new_article = Article.new(:folder => @folder, :title => 'new_article_2')
      article_path(new_article, :site => @site, :folder => @folder).should == 
                  "/#{@site.name}/#{@folder.name}"
    end
    
    it "should return the path for update action when edit action requested" do
      params[:action] = 'edit'
      params[:site] = @site.name
      params[:folder] = @folder.name
      article_path(@article).should == "/#{@site.name}/#{@folder.name}/#{@article.id}"
    end

    it "should return the path for update action when edit action requested." +
      "(optional parameter is included)." do
      params[:action] = 'edit'
      params[:site] = @site.name
      params[:folder] = @folder.name
      params[:page] = '2'
      article_path(@article, url_options_from_params).should == 
        "/#{@site.name}/#{@folder.name}/#{@article.id}?page=2"
    end


    it "should return the path for update action when update action requested" do
      params[:action] = 'update'
      params[:site] = @site.name
      params[:folder] = @folder.name
      article_path(@article).should == "/#{@site.name}/#{@folder.name}/#{@article.id}"
    end

    it "should return the path for create action when new action requested" do
      params[:action] = 'new'
      params[:site] = @site.name
      params[:folder] = @folder.name
      new_article = Article.new(:title => 'new_article_2')
      article_path(new_article).should == 
                  "/#{@site.name}/#{@folder.name}"
    end

    it "should return the path for create action when create action requested" do
      params[:action] = 'create'
      params[:folder] = @folder.name
      new_article = Article.new(:title => 'new_article_2')
      article_path(new_article, :site => @site).should == 
                  "/#{@site.name}/#{@folder.name}"
    end

  end

  
  describe "edit article path" do
    
    it "should return the path for edit action " + 
      "(A site is specified as an option.)" do
      edit_article_path(@article, :site => @site, :folder => @folder).should == 
          "/#{@site.name}/#{@folder.name}/#{@article.id}/edit"
    end

    it "should return the path for edit action " do
      params[:site] = @site.name
      params[:folder] = @folder.name
      edit_article_path(@article).should == 
          "/#{@site.name}/#{@folder.name}/#{@article.id}/edit"
    end

    it "should return the path for edit action (optional parameter is included) " do
      params[:site] = @site.name
      params[:folder] = @folder.name
      params[:page] = '2'
      edit_article_path(@article,url_options_from_params).should == 
          "/#{@site.name}/#{@folder.name}/#{@article.id}/edit?page=2"
    end
  
  end

  describe "new article path" do
    
    it "should return the path for new action " + 
      "(A site is specified as an option.)" do
      new_article_path(:site => @site,:folder => @folder).should == 
          "/#{@site.name}/#{@folder.name}/new"
    end

    it "should return the path for new action " do
      params[:site] = @site.name
      params[:folder] = @folder.name
      new_article_path.should == "/#{@site.name}/#{@folder.name}/new"
    end

    it "should return the path for new action (optional parameter is included)" do
      params[:site] = @site.name
      params[:folder] = @folder.name
      params[:page] = '2'
      new_article_path(url_options_from_params).should == 
          "/#{@site.name}/#{@folder.name}/new?page=2"
    end
  
  end


  describe "articles path" do
    
    it "should return the path for  index action " + 
      "(A site is specified as an option.)" do
      articles_path(:site => @site, :folder => @folder).should == 
          "/#{@site.name}/#{@folder.name}"
    end

    it "should return the path for index action " do
      params[:site] = @site.name
      params[:folder] = @folder.name
      articles_path.should == "/#{@site.name}/#{@folder.name}"
    end

    it "should return the path for index action (optional parameter is included)" do
      params[:site] = @site.name
      params[:folder] = @folder.name
      params[:page] = '2'
      articles_path(url_options_from_params).should == 
          "/#{@site.name}/#{@folder.name}?page=2"
    end

    it "should return the path for list action " + 
      "(A site is specified as an option.)" do
      articles_path(:site => @site, :folder => @folder, :action => :list).should == 
          "/#{@site.name}/#{@folder.name}/list"
    end

    it "should return the path for list action " do
      params[:site] = @site.name
      params[:folder] = @folder.name
      articles_path(:action => :list).should == "/#{@site.name}/#{@folder.name}/list"
    end
  
  end
  
end
