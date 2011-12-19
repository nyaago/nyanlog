class WidgetSetsController < ApplicationController
  
  # GET :site/widget_sets
  # 
  def index
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_sets = @site.widget_sets.can_manage_for(@current_user).listing
    respond_to do |format|
      format.html { render :action => :index}
    end
  end
  
  # GET :site/widget_sets/new
  # 
  def new
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_set = WidgetSet.new(:site => @site)
    generate_selections!(@site)
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end

  # POST :site/widget_sets
  # 
  def create
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_set = WidgetSet.new
    @widget_set.attributes = params[:widget_set]
    @widget_set.site = @site
    begin
      @widget_set.save!(:validate => true)
      flash[:notice] = message(:widget_sets, :created)
      return redirect_to :action => 'index'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@site)
      render :action => :new
    end
  end

  # GET :site/widget_sets/:id/edit
  #
  def edit
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_set = @site.widget_sets.by_id(params[:id]).can_manage_for(@current_user).first or 
                    (render_404 and return)
    generate_selections!(@site)
        respond_to do |format|
      format.html  { render :action => :edit}
    end
  end

  # PUT :site/widget_sets/:id
  #
  def update
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_set = @site.widget_sets.by_id(params[:id]).first or (render_404 and return)
    @widget_set.attributes = params[:widget_set]
    begin
      @widget_set.save!(:validate => true)
      flash[:notice] = message(:widget_sets, :updated)
      return redirect_to :action => 'index'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@site)
      render :action => :edit
    end
  end

  # DELETE :site/widget_sets/:id
  def destroy
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @widget_set = @site.widget_sets.by_id(params[:id]).first or (render_404 and return)
    @widget_set.destroy
    flash[:notice] = message(:widget_sets, :destroyed)
    redirect_to :action => :index
  end

  # フォームでの選択肢となるコレクションの生成
  def generate_selections!(site)
    @users = User.can_own_of(site).listing
  end
  
end
