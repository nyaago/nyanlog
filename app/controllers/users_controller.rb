class UsersController < ApplicationController
  
  PER_PAGE = 8
  
  # GET users
  def index
    unless current_user.can_manage_users?
      return render_404
    end
    @site = 
    if params[:site]
      Site.find_by_name(params[:site])
    else
      unless current_user.is_admin
        current_user.site
      else
        nil
      end
    end
    unless current_user.can_manage_site?(@site)
      return render_404
    end
    @users = User.filter_by_user(current_user).listing.page(params[:page]).per(PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET users/edit/:id
  def edit
    @user = User.find_by_id(params[:id])
    if @user.nil?
      return render_404
    end
    load_sites_for_edit!
    unless current_user.can_manage_site?(@site)
      return render_404
    end
    unless current_user.can_manage_user?(@user)
      return render_404
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET users/new
  def new
    @user = User.new
    load_sites_for_edit!    
    unless current_user.can_manage_site?(@site)
      return render_404
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # PUT users/update/:id
  def update
    @user = User.find_by_id(params[:id])
    if @user.nil?
      return render_404
    end
    unless current_user.can_manage_user?(@user)
      return render_404
    end
    @user.attributes = params[:user].permit(User.accessible_attributes_by_admin)
    begin
      @user.save!(:validate => true)
      flash[:notice] = message(:users, :updated)
      return redirect_to users_path
    rescue ActiveRecord::RecordInvalid  => ex
      load_sites_for_edit!
      render :action => :new
    rescue => ex
      p ex.message
      raise ex
    end
  end

  # POST users/create
  def create
    @user = User.new(params[:user].permit(User.accessible_attributes_by_admin))
    begin
      @user.save!(:validate => true)
      flash[:notice] = message(:users, :created)
      return redirect_to users_path
    rescue ActiveRecord::RecordInvalid  => ex
      load_sites_for_edit!
      render :action => :new
    end
  end

  # DELETE users/destroy
  def destroy
    @user = User.find_by_id(params[:id])
    if @user.nil?
      return render_404
    end
    unless current_user.can_manage_user?(@user)
      return render_404
    end
    begin
      @user.destroy
      flash[:notice] = message(:users, :destroyed)
      return redirect_to users_path
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => :new
    end
  end

  private
  
  def load_sites_for_edit!
    @site = 
    if params[:site]
      Site.find_by_name(params[:site])
    else
      unless current_user.is_admin
        current_user.site
      else
        nil
      end
    end
    @sites = 
    if @site.nil?
      @sites = Site.listing
    end
    @folders = 
    if @site
      @site.folders.opened.listing
    else
      nil
    end
  end

end
