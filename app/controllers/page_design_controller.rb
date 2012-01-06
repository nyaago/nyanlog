class PageDesignController < ApplicationController
  
  # get :site(/:folder)/page_design/header_image
  # == requiest parameters
  # * :site
  def header_image
    @site ||= Site.find_by_name(params[:site]) or (head(:not_found) and return )
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    @page_design = 
    if @folder
      @folder.active_page_design
    else
      @site.page_design  
    end or (head(:not_found) and return )
    path = @page_design.header_image.path
    unless File.exist?(path)
      head(:bad_request) and return 
    end
    send_file_options = {:type => @page_design.header_image.content_type ,
                        :disposition => 'inline'
                        }
    send_file(path, send_file_options)
  end

  # get :site(/:folder)/page_design/header_image
  # == requiest parameters
  # * :site
  def background_image
    @site ||= Site.find_by_name(params[:site]) or (head(:not_found) and return )
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    @page_design = 
    if @folder
      @folder.active_page_design
    else
      @site.page_design  
    end or (head(:not_found) and return )
    path = @page_design.background_image.path
    unless File.exist?(path)
      head(:bad_request) and return 
    end
    send_file_options = {:type => @page_design.background_image.content_type ,
                        :disposition => 'inline'
                        }
    send_file(path, send_file_options)
  end
  
  # GET :site(/:folder)/page_design/header
  def header
    edit
  end

  # GET :site(/:folder)/page_design/background
  def background
    edit
  end
  
  # GET :site(/:folder)/page_design/html_css
  def html_css
    edit
  end
  
  # PUT :site(/:folder)/page_design
  def update
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    @page_design = 
    if @folder
      @folder.page_design
    else
      @site.page_design
    end || PageDesign.new
    @page_design.attributes = params[:page_design]
    @page_design.site = @site
    @page_design.folder = @folder
    begin
      @page_design.save!(:validate => true)
      flash[:notice] = message(:page_design, :updated)
      return redirect_to :action => params[:back_action] || :header, :folder => @folder && @folder.name
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => params[:back_action] || :header
    end
  end
  
  # PUT :site/page_design/delete_header_image
  def delete_header_image
    @site ||= Site.find_by_name(params[:site]) or (head(:not_found) and return )
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    page_design = 
    if @folder
      @folder.page_design
    else
      @site.page_design  
    end or (head(:not_found) and return )
    begin
      page_design.header_image.destroy
      page_design.save!(:validate => false)
      flash[:notice] = message(:page_design, :header_image_deleted)
      return redirect_to :action => :header
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => :header
    end
  end

  # PUT :site/page_design/delete_background_image
  def delete_background_image
    @site ||= Site.find_by_name(params[:site]) or (head(:not_found) and return )
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    page_design = 
    if @folder
      @folder.page_design
    else
      @site.page_design  
    end or (head(:not_found) and return )
    begin
      page_design.background_image.destroy
      page_design.save!(:validate => false)
      flash[:notice] = message(:page_design, :background_image_deleted)
      return redirect_to :action => :background
    rescue ActiveRecord::RecordInvalid  => ex
      render :action => :background
    end
  end
  
  private
  
  def edit
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    @folder ||= @site.folders.by_name(params[:folder]).first
    render_404 and return if @folder.nil? && !current_user.can_manage_site?(@site)
    @page_design = 
    if @folder
      @folder.page_design
    else
      @site.page_design
    end || PageDesign.new
  end
  
end
