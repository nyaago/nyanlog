class SitesController < ApplicationController
  
  PER_PAGE = 8
  
  # GET sites
  def index
    @site = 
    if params[:site]
      Site.find_by_name(params[:site])
    end
    @sites = Site.listing.paginate(:page => params[:page], :per_page => PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /
  # if the default site is set, it redirects to folders/index,
  # otherwise it redirects to site/index
  def default
    @site = if setting = AppSetting.setting; setting.default_site;else;nil;end
    if @site
      redirect_to :controller => :folders, :action => :index, :site => @site.name
    else
      redirect_to :controller => :sites, :action => :index
    end
  end

  # GET sites/edit/:id
  def edit
    @site = Site.find_by_id(params[:id])  or (render_404 and return)
    generate_selections!(@site)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET sites/new
  def new
    @site = Site.new
    generate_selections!(@site)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # PUT sites/update/:id
  def update
    @site = Site.find_by_id(params[:id]) or (render_404 and return)
    @site.attributes = params[:site]
    begin
      ActiveRecord::Base.transaction do
        @site.save!(:validate => true)
        flash[:notice] = message(:sites, :updated)
        return redirect_to sites_path(:site => @site.name)
      end
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@site)
      render :action => :new
    rescue => ex
      p ex.message
      raise ex
    end
  end

  # POST sites/create
  def create
    @site = Site.new(params[:site])
    begin
      ActiveRecord::Base.transaction do
        @site.save!(:validate => true)
        flash[:notice] = message(:sites, :created)
        return redirect_to sites_path(:site => @site.name)
      end
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@site)
      render :action => :new
    end
  end

  def detail
  end

  # DELETE sites/destroy
  def destroy
    @site = Site.find_by_id(params[:id]) 
    if @site.nil?
      flash[:notice] = message(:sites, :not_found)
      return redirect_to :edit
    end
    begin
      @site.destroy
      flash[:notice] = message(:sites, :destroyed)
      return redirect_to sites_path
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => :new
    end
  end

  # GET sites/:id/theme_list
  def theme_list
    @site ||= Site.find_by_id(params[:id]) or (render_404 and return)
    @themes = Design::Theme.array
    respond_to do |format|
      format.html # 
    end
  end
  
  # PUT sites/:id/selec_theme
  def select_theme
    @site ||= Site.find_by_id(params[:id]) or (render_404 and return)
    @site.attributes = params[:site]
    begin
      ActiveRecord::Base.transaction do
        @site.save!(:validate => true)
        flash[:notice] = message(:sites, :theme_updated)
        return redirect_to url_for(:action => :theme_list, :controller => :sites, :id => @site.id)
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
  def generate_selections!(site)
    @folders = site.folders.opened.listing
  end
  
#  def index_path
    
#  end

end
