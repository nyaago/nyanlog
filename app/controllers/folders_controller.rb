# = FoldersController
#
class FoldersController < ApplicationController

  include FoldersHelper
  include ::OpenAndCloseAt

  PER_PAGE = 8

  # GET :site/folders
  # = instace fields receiced to the view
  # * @site
  # * @folders
  def index
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folders = @site.folders.listing.
                paginate(:per_page => PER_PAGE, :page => params[:page])
    respond_to do |format|
      format.html { render :action => :list}
    end
  end

  
  # GET :site/folders/list
  # = instace fields receiced to the view
  # * @site
  # * @folders
  def list
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folders = @site.folders.listing.
                paginate(:per_page => PER_PAGE, :page => params[:page])
    respond_to do |format|
      format.html { render :action => :list}
    end
  end

  # GET :site/folders/new
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  # * @ordering_types - How to put a article in order 
  # * @max_article_count_by_page - The max of the articles in every page.
  def new
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to :action => :list
    end
    @folder = Folder.new(:site => @site)
    generate_selections!(@folder)
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end

  # POST :site/folders
  # create a new folder,and redirect to :site/folders/list
  def create
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folder = Folder.new(:site => @site)
    @folder.attributes = params[:folder]
    begin
      @folder.save!(:validate => true)
      flash[:notice] = message(:folders, :created)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@folder)
      render :action => :new
    end
  end
  
  # GET :site/folders/:id/edit
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  # * @ordering_types - How to put a article in order 
  # * @max_article_count_by_page - The max of the articles in every page.
  def edit
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folder = @site.folders.by_name(params[:name]).first
    generate_selections!(@folder)
    if @folder.nil?
      flash[:notice] = message(:folder, :not_found)
      redirect_to '/'
    end
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end
  
  # PUT :site/folders/:id
  # update the folder,and redirect to :site/folders/list
  def update
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folder = @site.folders.by_name(params[:name]).first
    if @folder.nil?
      flash[:notice] = message(:folder, :not_found)
      redirect_to :action => :list
    end
    @folder.attributes = params[:folder]
    begin
      @folder.save!(:validate => true)
      flash[:notice] = message(:folders, :updated)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@folder)
      render :action => :edit
    end
  end
  
  # DELETE :site/folders/:id
  # destroy the folder,and redirect to :site/folders/list
  def destroy
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      flash[:notice] = message(nil, :site_not_found)
      redirect_to '/'
    end
    @folder = @site.folders.by_name(params[:name]).first
    if @folder.nil?
      flash[:notice] = message(:folder, :not_found)
      redirect_to :action => :list
    end
    @folder.destroy
    flash[:notice] = message(:folders, :destroyed)
    redirect_to :action => :list
  end
  
  private 
  
  # フォームでの選択肢となるコレクションの生成
  def generate_selections!(folder)
    @years = years(folder)
    @months = months
    @days = days
    @hours = hours
    @minutes = minutes
    @ordering_types = Folder.ordering_types
    @max_article_count_by_page = Folder::MAX_ARTICLE_COUNT_BY_PAGE
  end
  
  
end
