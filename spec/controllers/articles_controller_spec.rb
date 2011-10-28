require 'spec_helper'

describe ArticlesController do
  
  class ApplicationController
    def checks_authenticated
      true
    end
  end
  
  before  do 
    @site = Site.make
    @folder = Folder.make(:site => @site)
    @article = Article.make(:folder => @folder)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :site => @site.name, :folder => @folder.name
      response.should be_success
    end
  end

  describe "GET 'list'" do
    it "returns http success" do
      get 'list', :site => @site.name, :folder => @folder.name
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', :site => @site.name, :folder => @folder.name, :id => @article.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new', :site => @site.name, :folder => @folder.name
      response.should be_success
    end
  end


  describe "POST" do
    it "returns http success" do
      post 'create', :site => @site.name, :folder => @folder.name, 
                      :article => { :title => 'title2'}
      response.should be_redirect
    end
  end

  describe "PUT " do
    it "returns http success" do
      put 'update', :site => @site.name, :folder => @folder.name, :id => @article.id
      response.should be_redirect
    end
  end


  describe "DELETE" do
    it "returns http success" do
      delete 'destroy', :site => @site.name, :folder => @folder.name, :id => @article.id
      response.should be_redirect
    end
  end

end