# = AppSettingsController
# the controller for applicaton  settings (AppSetting)
class AppSettingsController < ApplicationController
  
  include AppSettingsHelper
  
  # GET /app_settings
  # GET /app_settings.json
  def index
    if app_setting = AppSetting.all[0]
      redirect_to :action => :edit, :id => app_setting.id
    else
      redirect_to :action => :new
    end
  end

  # GET /app_settings/1
  def show
    return render_404
  end

  # GET /app_settings/new
  def new
    if app_setting = AppSetting.all[0]
      return redirect_to '/'
    end
    @app_setting = AppSetting.new
    @sites = Site.all
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /app_settings/1/edit
  def edit
    unless app_setting = AppSetting.all[0]
      return redirect_to '/'
    end
    @app_setting = AppSetting.find(params[:id])
    @sites = Site.all
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /app_settings
  def create
    @app_setting = AppSetting.new(params[:app_setting].permit(AppSetting.accessible_attributes))
    respond_to do |format|
      if @app_setting.save
        format.html { redirect_to '/', 
            :notice => message(:app_settings, :created) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /app_settings/1
  def update
    @app_setting = AppSetting.find(params[:id])
    respond_to do |format|
      if @app_setting.update_attributes(params[:app_setting].permit(AppSetting.accessible_attributes))
        format.html { redirect_to '/', 
            :notice => message(:app_settings, :updated) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /app_settings/1
  def destroy
    return render_404
  end
end
