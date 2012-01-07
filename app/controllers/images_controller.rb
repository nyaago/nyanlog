class ImagesController < ApplicationController

  include ArticlesHelper
  include Attribute::OpenAndCloseAt

  skip_auth :index

  PER_PAGE = 8

  # GET :site/:folder/images/list
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @articles
  def list
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @images = @folder.images.listing(@folder).page(params[:page]).per(PER_PAGE)
    respond_to do |format|
      format.html { render :action => :list}
    end
  end
  
  # GET :site/images/selection_list
  # GET :site/:folder/images/selection_list
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @articles
  def selection_list
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = 
    unless params[:folder].blank?
      @site.folders.by_id(params[:folder]).first or (render_404 and return)
    end
    
    @images = 
    if @folder
      @folder.images.listing(@folder)
    else
      Image.editable_for(current_user)
    end.page(params[:page]).per(PER_PAGE)
    @folders = 
    if current_user.is_admin
      @site.folders
    else
      Folder.editable_for(current_user)
    end
    respond_to do |format|
      format.html { render :action => :selection_list, :layout => 'simple'}
    end
  end
  
  
  # GET :site/:folder/images/new
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  def new
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = Image.new(:folder => @folder)
    generate_selections!(@image)
    respond_to do |format|
      format.html
    end
  end

  # GET :site/:folder/images/:id/edit
  # = instace fields received to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  def edit
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = @folder.images.by_id(params[:id]).first
    if @image.nil?
      return render_404
    end
    generate_selections!(@image)
    respond_to do |format|
      format.html
    end
  end
  
  # POST :site/:folder/images
  def create
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = Image.new(:folder => @folder)
    @image.attributes = params[:image]
    begin
      @image.save!(:validate => true)
      flash[:notice] = message(:images, :created)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@image)
      render :action => :new
    end
  end

  # PUT :site/:folder/images/:id
  def update
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = @folder.images.by_id(params[:id]).first
    if @image.nil?
      return render_404
    end
    @image.attributes = params[:image]
    begin
      @image.save!(:validate => true)
      flash[:notice] = message(:images, :updated)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@image)
      render :action => :edit
    end
  end

  # DELETE :site/:folder/:id
  def destroy
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = @folder.images.by_id(params[:id]).first
    begin
      @image.destroy
      flash[:notice] = message(:articles, :destroyed)
      return redirect_to :action => 'list'
    end
  end
  
  # get :site/:folder/images/:id
  # get :site/:folder/images/:id/:style 
  # == requiest parameters
  # * :site
  # * :id
  # * :style - original (default) | medium | small | thumb 
  def show
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      head(:not_found) and return 
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      head(:not_found) and return 
    end
    @image = @folder.images.by_id(params[:id]).first
    if @image.nil?
      return head(:not_found)
    end
    path = @image.image.path(params[:style])
    p "file path = #{path}"
    #unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')
    unless File.exist?(path)
      head(:bad_request) and return 
    end
    send_file_options = {:type => @image.image.content_type ,
                        :disposition => 'inline'
                        }
#    case ::AppConfig::Application.instance.send_file_mathod
#      when 'x_sendfile'; send_file_options[:x_sendfile] = true
#      when 'x_accel_redirect' then 
#        head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and 
#        return
#    end
     send_file(path, send_file_options)
  end


  # PUT :site/:folder/images/:id/move_to_front (ajax)
  # moves the article ahead
  def move_ahead
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = @folder.images.by_id(params[:id]).first
    if @image.nil?
      return render_404
    end
    begin
      ActiveRecord::Base.transaction do
        @image.move_ahead!
      end
    end
    @images = @folder.images.listing(@folder).
                .page(params[:page]).per(PER_PAGE)
    respond_to do |format|
      format.html { render :file => '/images/_image_table', :layout => false}
    end
  end

  # PUT :site/:folder/images/:id/move_to_front (ajax)
  # moves the article behind
  def move_behind
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @image = @folder.images.by_id(params[:id]).first
    if @image.nil?
      return render_404
    end
    begin
      ActiveRecord::Base.transaction do
        @image.move_behind!
      end
    end
    @images = @folder.images.listing(@folder).
                .page(params[:page]).per(PER_PAGE)
    respond_to do |format|
      format.html { render :file => '/images/_image_table', :layout => false}
    end
  end


  private 
  
  # フォームでの選択肢となるコレクションの生成
  def generate_selections!(image)
    @years = years(image)
    @months = months
    @days = days
    @hours = hours
    @minutes = minutes
  end
  

end
