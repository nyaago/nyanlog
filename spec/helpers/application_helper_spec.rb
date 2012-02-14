require 'spec_helper'


describe ApplicationHelper do
  
  require 'articles_helper'
  include ArticlesHelper
  require 'page_design_helper'
  include PageDesignHelper
  
  before  do 
    @site = Site.make
    @folder = Folder.make(:site => @site)
    @articles = (1..20).collect do
      Article.make(:folder => @folder)
    end
    @article = @articles[0]
  end
  
  def params()
    @params ||= {}
  end
  
  def self.current_site=(site);@current_site=site;end
  def self.current_folder=(folder);@current_folder=folder;end
  def self.current_site;@current_site = if  @current_site; @current_site.reload;end;end
  def self.current_folder;@current_folder = if @current_folder;@current_folder.reload;end;end
  
  
  describe "link_to_monthly_articles " do
    
    it " by string " do
      re = Regexp.new("#{@site.name}/#{@folder.name}/#{Date.today.year}/#{Date.today.month}/month")
      link_to_monthly_articles(Date.today.strftime("%Y/%m/%d"), @folder).should match(re)
    end

    it " by date " do
      re = Regexp.new("#{@site.name}/#{@folder.name}/#{Date.today.year}/#{Date.today.month}/month")
      link_to_monthly_articles(Date.today, @folder).should match(re)
    end
  
  end

  describe "link_to_article " do
    
    it " by record " do
      re = Regexp.new("#{@site.name}/#{@folder.name}/#{@article.id}/show")
      link_to_article(@article).should match(re)
    end
  
  end

  describe "link_to_folder " do
    
    it " by record " do
      re = Regexp.new("#{@site.name}/#{@folder.name}\\\"\>")
      link_to_folder(@folder).should match(re)
    end
  
  end
  
  describe "header image tag " do
    it " include image url" do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.header_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      

      re = Regexp.new("#{@site.name}/#{@folder.name}/page_design/header_image")
      
      header_image_tag.should match(re)
      
    end

    it " include image url (when folder not assigned)" do
      current_folder = nil
      current_site = @site
      page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.header_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_site.page_design = page_design

      re = Regexp.new("#{@site.name}/page_design/header_image")
      header_image_tag.should match(re)
      
    end

  end

  describe "header_image_exist?   " do

    it " eixst " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.header_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_folder.page_design = page_design

      
      header_image_exist?.should == true
      
    end
    
    it " eixst (when folder not assigned) " do
      current_folder = nil
      current_site = @site
      page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.header_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_site.page_design = page_design
 #     page_design = page_design.reload
      header_image_exist?.should == true
      
    end


    it " not eixst " do

      current_folder = @folder
      current_site = @site
      header_image_exist?.should == false
      
    end

  end

  describe "background_image_exist?   " do
    it " eixst (when folder not assigned) " do
      current_folder = nil
      current_site = @site
      page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.background_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      @site = @site.reload
      page_design.save!(:validate => true)
      current_site.page_design = page_design

      background_image_exist?.should == true
    end

    it " eixst " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.background_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_folder.page_design = page_design

      background_image_exist?.should == true

    end

    it " not eixst " do

      current_folder = @folder
      current_site = @site
      background_image_exist?.should == false

    end
  end
  

  describe "background_style " do
    it " include valid background image url" do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.background_image = uploaded_file('user.jpg', 'image/jpg')
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new("background-image: url(.+#{@site.name}/#{@folder.name}/page_design/background_image)")

      background_style.should match(re)

    end
    
    it " include background-position " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.background_position = 'left'
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.background_interited_from_site = false
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new("background-position:.*left")

      background_style.should match(re)
    end

    it " include background-attachment " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.background_attachment = 'scroll'
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.background_interited_from_site = false
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new("background-attachment:.*scroll")

      background_style.should match(re)
    end

    it " include background-color " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      begin
        page_design.background_color = '#cccccc'
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.background_interited_from_site = false
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new("background-color:.*#cccccc")

      background_style.should match(re)
    end

    it " include background-position (interited from site) " do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      site_page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.background_position = 'left'
        site_page_design.background_position = 'right'
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.background_interited_from_site = true
      page_design.save!(:validate => true)
      site_page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      current_site.page_design = site_page_design
      current_site.save!(:validate => false)

      re = Regexp.new("background-position:.*right")

      background_style.should match(re)
    end

    it " include background-color ( interited from site)" do
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      site_page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.background_color = '#cccccc'
        site_page_design.background_color = '#aaaaaa'
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.background_interited_from_site = true
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new("background-color:.*#aaaaaa")
      current_site.page_design = site_page_design
      current_site.save!(:validate => false)

      background_style.should match(re)
    end

  end

  describe "user_stylesheet" do
    
    it "  user stylesheet is returned (inherited from site )" do
      stylesheet = "body {background-color: red}"
      site_stylesheet = "body {background-color: blue; font-size: 12px}"
      current_folder = @folder
      current_site = @site
#      page_design = PageDesign.new(:folder => @folder, :site => @site)
      site_page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        site_page_design.stylesheet = site_stylesheet
      rescue => ex
        p ex.backtrace
        raise ex
      end
 #     page_design.save!(:validate => true)
      site_page_design.save!(:validate => true)
#      current_folder.page_design = page_design
#      current_folder.save!(:validate => false)
      current_site.page_design = site_page_design
      current_site.save!(:validate => false)
      
      re = Regexp.new(site_stylesheet)

      user_stylesheet.should match(re)
    end
    

    it "  user stylesheet is returned " do
      stylesheet = "body {background-color: red}"
      current_folder = @folder
      current_site = @site
      page_design = PageDesign.new(:folder => @folder, :site => @site)
      site_page_design = PageDesign.new(:folder => nil, :site => @site)
      begin
        page_design.stylesheet = stylesheet
      rescue => ex
        p ex.backtrace
        raise ex
      end
      page_design.save!(:validate => true)
      current_folder.page_design = page_design
      current_folder.save!(:validate => false)
      re = Regexp.new(stylesheet)

      user_stylesheet.should match(re)
    end
    
  end

  
end
