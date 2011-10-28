require 'spec_helper'

describe SitesController do

  class ApplicationController
    def checks_authenticated
      true
    end
  end
  
  before  do 
    @site = Site.make
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', :id => @site.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end


  describe "POST" do
    it "returns http success" do
      post 'create', :site => {:name => 'site2', :title => 'title2'}
      response.should be_redirect
    end
  end

  describe "PUT " do
    it "returns http success" do
      put 'update', :id => @site.id
      response.should be_redirect
    end
  end


  describe "DELETE" do
    it "returns http success" do
      delete 'destroy', :id => @site.id
      response.should be_redirect
    end
  end

end
