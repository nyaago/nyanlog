class MenuItemsController < ApplicationController
  
  # GET :site/menu_items/:menu_type
  # = instace fields receiced to the view
  # * @site
  # * @menu
  # * @menu_items
  def index
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    @parent_menu_item = 
    if params[:parent_id]
      @menu.menu_items.by_id(params[:parent_id]).first
    end
    if params[:parent_id] && @parent_menu_item.nil?
      return render_404
    end
    
    @menu_items = @menu.menu_items.by_parent(@parent_menu_item).listing
    @ancestors = if @parent_menu_item;[@parent_menu_item] + @parent_menu_item.ancestors;else;[];end
    respond_to do |format|
      format.html { render :action => :index}
    end
  end

  # GET :site/menu_items/:menu_type/new 
  # = instace fields receiced to the view
  # * @site
  # * @menu
  # * @menu_item
  # * @folders
  def new
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    
    @menu_item = MenuItem.new(:menu => @menu)
    @menu_item.parent_id = params[:parent_id]
    generate_selections!(@menu_item)
    respond_to do |format|
      format.html  { render :action => :new}
    end
  end

  # GET :site/menu_items/:menu_type/:id/edit
  # = instace fields receiced to the view
  # * @site
  # * @menu
  # * @menu_item
  # * @folders
  def edit
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    @menu_item = @menu.menu_items.by_id(params[:id]).first
    if @menu_item.nil?
      return render_404
    end
    
    if params[:parent_id]
      parent = @menu.menu_items.by_id(params[:parent_id]).first
      if parent.nil?
        return render_404
      end
      @menu_item.parent = parent
    end
    
    generate_selections!(@menu_item)
    respond_to do |format|
      format.html 
    end
  end

  # POST :site/menu_items/:menu_type
  # 
  def create
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    
    @menu_item = MenuItem.new(:menu => @menu)
    @menu_item.attributes = params[:menu_item]
    
    begin
      @menu_item.save!(:validate => true)
      flash[:notice] = message(:menu_items, :created)
      return redirect_to :action => 'index', :parent_id => @menu_item.parent_id
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@menu_item)
      render :action => :new
    end
  end
  
  # PUT :site/menu_items/:menu_type/:id
  def update
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    @menu_item = @menu.menu_items.by_id(params[:id]).first
    if @menu_item.nil?
      return render_404
    end
    @menu_item.attributes = params[:menu_item]
    generate_selections!(@menu_item)
    
    begin
      @menu_item.save!(:validate => true)
      flash[:notice] = message(:menu_items, :created)
      return redirect_to :action => 'index', :parent_id => @menu_item.parent_id
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@menu_item)
      render :action => :edit
    end
  end
  
  
  # PUT :site/menu_items/:menu_type/:id/move_ahead (ajax)
  # moves the menu item ahead
  def move_ahead
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    @menu_item = @menu.menu_items.by_id(params[:id]).first
    if @menu_item.nil?
      return render_404
    end
    
    begin
      ActiveRecord::Base.transaction do
        @menu_item.move_ahead!
      end
    end
    @menu_items = @menu.menu_items.listing
    respond_to do |format|
      format.html { render :file => '/menu_items/_menu_item_table', :layout => false}
    end
  end

  # PUT :site/menu_items/:menu_type/:id/move_behind (ajax)
  # moves the menu item behind
  def move_behind
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @menu = @site.menus.by_menu_type(params[:menu_type]).first
    if @menu.nil?
      return render_404
    end
    @menu_item = @menu.menu_items.by_id(params[:id]).first
    if @menu_item.nil?
      return render_404
    end
    
    begin
      ActiveRecord::Base.transaction do
        @menu_item.move_behind!
      end
    end
    @menu_items = @menu.menu_items.listing
    respond_to do |format|
      format.html { render :file => '/menu_items/_menu_item_table', :layout => false}
    end
  end

  private
  
  def generate_selections!(menu_item)
    @folders = @site.folders
  end
  
end
