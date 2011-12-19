module WidgetSetsHelper
  
  def widget_set_path(widget_set, options = {})
    url_for(options.merge({
    :action => 
      if options[:action].blank? 
        if params[:action] == 'edit' ||  params[:action] == 'update'
          'update'
        elsif params[:action] == 'new' ||  params[:action] == 'create'
          'create'
        else
          'index' 
        end
      else 
        options[:action] 
      end,
    :controller => 'widget_sets',
    :site => site(options) || if widget_set;widget_set.site.name;end,
    :id => 
      if widget_set.nil? 
        params[:id] 
      else
        if widget_set.respond_to?(:id)  # Folder model record
          unless widget_set.new_record?
            widget_set.id
          end
        else  # 
          widget_set 
        end 
      end}
      ))
  end
  
  def widget_set_url(widget_set, options = {})
    widget_set_path(widget_set, options.merge({:only_path => false}))
  end
  
  def new_widget_set_path(options = {})
    url_for(options.merge( {
    :controller => 'widget_sets',
    :action => :new,
    :site => site(options)
    } ))
  end

  def new_widget_set_url(options = {})
    new_widget_set_path(options.merge({:only_path => false}))
  end


  def edit_widget_set_path(widget_set,options = {})
    url_for(options.merge( {
    :controller => 'widget_sets',
    :action => :edit,
    :id => 
      if widget_set.nil? 
        params[:id] 
      else
        if widget_set.respond_to?(:id) 
          widget_set.id
        else 
          widget_set 
        end 
      end,
    :site => site(options)
    } ))
  end
  
  def edit_widget_set_url(widget_set, options = {})
    edit_widget_set_path(widget_set, options.merge({:only_path => false}))
  end
  

  def widget_sets_path(options = {})
    url_for(options.merge( {
    :controller => 'widget_sets',
    :action => 
      if options[:action].blank? 
        if params[:action] == 'new' ||  params[:action] == 'create'
          'create'
        elsif params[:action] == 'show' 
          'show'
        elsif params[:action] == 'index' 
          'index'
        else
          'index' 
        end
      else 
        options[:action] 
      end,
    :site => site(options)
    } ))
  end
  
  def widget_sets_url(options = {})
    widget_sets_path(options.merge({:only_path => false}))
  end

  private
  
  def site(options)
    site = options[:site]
    if site.nil? 
      params[:site]
    else
      if site.respond_to?(:name) 
        site.name 
      else 
        site 
      end
    end
  end
  
  
end
