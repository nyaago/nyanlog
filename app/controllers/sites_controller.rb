class SitesController < ApplicationController
  
  PER_PAGE = 8
  
  # GET sites
  def index
    @sites = Site.listing.paginate(:page => params[:page], :per_page => PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET sites/edit/:id
  def edit
    @site = Site.find_by_id(params[:id])
    if @site.nil?
      flash[:notice] = message(:sites, :not_found)
      return redirect_to :index
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET sites/new
  def new
    @site = Site.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # PUT sites/update/:id
  def update
    @site = Site.find_by_id(params[:id])
    if @site.nil?
      flash[:notice] = message(:sites, :not_found)
      return redirect_to :edit
    end
    @site.attributes = params[:site]
    begin
      @site.save!(:validate => true)
      flash[:notice] = message(:sites, :updated)
      return redirect_to sites_path
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => :new
    end
  end

  # POST sites/create
  def create
    @site = Site.new(params[:site])
    begin
      @site.save!(:validate => true)
      flash[:notice] = message(:sites, :created)
      return redirect_to sites_path
    rescue ActiveRecord::RecordInvalid  => ex
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


  private
  
#  def index_path
    
#  end

end
