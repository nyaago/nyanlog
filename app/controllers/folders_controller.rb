# = FoldersController
#
class FoldersController < ApplicationController

  skip_auth :index

  include FoldersHelper
  include Attribute::OpenAndCloseAt

  PER_PAGE = 8

  # GET :site/folders
  # it redirects to articles/index of default folder,
  def index
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    if current_user
      if current_user.default_folder
        if current_user.default_folder.site_id != @site.id
          return render_404
        end
        return redirect_to :controller => :articles, :action => :index, 
                            :folder => current_user.default_folder.name
      end
    end
    if @site.default_folder
      return redirect_to :controller => :articles, :action => :index, 
                          :folder => @site.default_folder.name
    end
    if @site.folders.count > 0
      return redirect_to :controller => :articles, :action => :index, 
                          :folder => @site.folders.first.name
    end
    return render_404
  end

  
  # GET :site/folders/list
  # = instace fields receiced to the view
  # * @site
  # * @folders
  def list
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folders = @site.folders.listing.page(params[:page]).per(PER_PAGE)
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
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = Folder.new(:site => @site)
    generate_selections!(@folder)
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end

  # POST :site/folders
  # create a new folder,and redirect to :site/folders/list
  def create
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
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
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = @site.folders.by_name(params[:name]).first or (render_404 and return)
    generate_selections!(@folder)
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end
  
  # PUT :site/folders/:id
  # update the folder,and redirect to :site/folders/list
  def update
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = @site.folders.by_name(params[:name]).first or (render_404 and return)
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
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = @site.folders.by_name(params[:name]).first or (render_404 and return)
    @folder.destroy
    flash[:notice] = message(:folders, :destroyed)
    redirect_to :action => :list
  end
  
  
  # GET :site/folders/:name/theme_list
  def theme_list
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = @site.folders.by_name(params[:name]).first or (render_404 and return)
    @themes = Design::Theme.array
    respond_to do |format|
      format.html # 
    end
  end
  
  # PUT :site/folders/:name/selec_theme
  def select_theme
    @site ||= Site.find_by_id(params[:site]) or (render_404 and return)
    @folder = @site.folders.by_name(params[:name]).first or (render_404 and return)
    @folder.theme_name = 
    if params[:folder] && params[:folder][:theme_name]
      params[:folder][:theme_name]
    else
      nil
    end
    begin
      ActiveRecord::Base.transaction do
        @folder.save!(:validate => true)
        flash[:notice] = message(:folders, :theme_updated)
        return redirect_to url_for(:action => :theme_list, :controller => :folders, 
                              :site => @site.name, :name => @folder.name)
      end
    rescue ActiveRecord::RecordInvalid  => ex
      @themes = Design::Theme.array
      render :action => :theme_list
    rescue => ex
      p ex.message
      raise ex
    end
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
    @users = User.can_own_folder_of(folder.site).listing
  end
  
  
  
end
