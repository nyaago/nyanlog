class WidgetSetElementsController < ApplicationController
  
  # GET :site/widget_set_elements/:widget_set
  def index
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    # selected elements
    @widget_set = @site.widget_sets.by_id(params[:widget_set]).can_manage_for(@current_user).first or  
                  (render_404 and return)
    @widget_set_elements = @widget_set.elements.listing
    # selectable widgets
    @selectable_widgets = AppConfig::Widget.array
    # 
    respond_to do |format|
      format.html { render :action => :index}
    end
  end
  
  def create
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    # selected elements
    @widget_set = @site.widget_sets.by_id(params[:widget_set]).can_manage_for(@current_user).first or  
                  (render_404 and return)
    clazz = unless params[:widget_type].blank?
      begin
        params[:widget_type].split(/::/).inject(Object) {|c,name| c.const_get(name) }
      rescue
        nil
      end
    else
      nil
    end
    if clazz.nil? 
      respond_to do |format|
        format.json  { render :json => { :status => "NG" } }
      end
      return
    end
    widget = clazz.new()
    begin
      ActiveRecord::Base.transaction do
        widget.save!(:validate => true) && 
        @widget_set_element = WidgetSetElement.create!(:widget_set => @widget_set,  
                                        :widget => widget
                                        ) 
        respond_to do |format|
          format.json do
            #p({:widget_set_element => @widget_set_element}.to_json.inspect)
            render :text => {:widget_set_element => @widget_set_element, :widget => widget}.to_json
          end
        end
      end
    rescue => ex      # error
      p ex.message
      respond_to do |format|
        format.json  { render :json => { :status => "NG" } }
      end
    end
    
  end
  
  def edit
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    # selected elements
    @widget_set_element = WidgetSetElement.find_by_id(params[:id])  or (render_404 and return)
    @widget_set = @site.widget_sets.by_id(@widget_set_element.widget_set_id).
                  can_manage_for(@current_user).first or  (render_404 and return)
    @widget_set.site_id == @site.id or (render_404 and return) 
    (@widget = @widget_set_element.widget) or  (render_404 and return) 
    redirect_to :controller => @widget.class.name.underscore, :action => :edit, 
                :id => @widget.id
  end
  
  def destroy
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    # selected elements
    widget_set_element = WidgetSetElement.find_by_id(params[:id])  or (render_404 and return)
    widget_set = @site.widget_sets.by_id(widget_set_element.widget_set_id).
                  can_manage_for(@current_user).first or  (render_404 and return)
    widget_set.site_id == @site.id or (render_404 and return) 
    widget = widget_set_element.widget
    widget_set_element.destroy
    respond_to do |format|
      format.json do
        #p({:widget_set_element => @widget_set_element}.to_json.inspect)
        render :text => {:widget_set_element => widget_set_element, :widget => widget}.to_json
      end
    end
  end

  def selected_list
    @site ||= Site.find_by_name(params[:site])  or (render_404 and return)
    # selected elements
    @widget_set = @site.widget_sets.by_id(params[:widget_set]).can_manage_for(@current_user).first or  
                  (render_404 and return)
    @widget_set_elements = @widget_set.elements.listing
    # 
    respond_to do |format|
      format.json do
        res = @widget_set_elements.collect do |widget_set_element|
          {:widget_set_element => widget_set_element, :widget => widget_set_element.widget}
        end
        render :text => res.to_json
      end
    end
  end

end
