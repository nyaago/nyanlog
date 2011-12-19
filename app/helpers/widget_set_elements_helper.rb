module WidgetSetElementsHelper
  
  def widget_set_element_path(widget_set_element, options = {})
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
    :controller => 'widget_set_elements',
    :site => site(options) || if widget_set;widget_set.name;end,
    :widget_set => 
      unless options[:widget_set].blank? 
        options[:widget_set]
      else
        params[:widget_set] || nil
      end,
    :id => 
      if widget_set_element.nil? 
        params[:id] 
      else
        if widget_set_element.respond_to?(:id)  # Folder model record
          unless widget_set_element.new_record?
            widget_set_element.id
          end
        else  # 
          widget_set_element 
        end 
      end}
      ))
  end
  
  def widget_set_element_url(widget_set, options = {})
    widget_set_element_path(widget_set, options.merge({:only_path => false}))
  end
  
  def new_widget_set_element_path(options = {})
    url_for(options.merge( {
    :controller => 'widget_set_elements',
    :action => :new,
    :widget_set => 
      unless options[:widget_set].blank? 
        options[:widget_set]
      else
        params[:widget_set] || nil
      end,
    :site => site(options)
    } ))
  end

  def new_widget_set_element_url(options = {})
    new_widget_set_element_path(options.merge({:only_path => false}))
  end


  def edit_widget_set_element_path(widget_set_element,options = {})
    url_for(options.merge( {
    :controller => 'widget_set_elements',
    :action => :edit,
    :id => 
      if widget_set_element.nil? 
        if options[:id]
          options[:id]
        else
          params[:id] 
        end
      else
        if widget_set_element.respond_to?(:id) 
          widget_set_element.id
        else 
          widget_set_element 
        end 
      end,
#    :widget_set => 
#      unless options[:widget_set].blank? 
#        options[:widget_set]
#      else
#        params[:widget_set] || nil
#      end,
    :site => site(options)
    } ))
  end
  
  def edit_widget_set_element_url(widget_set, options = {})
    edit_widget_set_element_path(widget_set, options.merge({:only_path => false}))
  end
  

  def widget_set_elements_path(options = {})
    url_for(options.merge( {
    :controller => 'widget_set_elements',
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
    :widget_set => 
      unless options[:widget_set].blank? 
        if options[:widget_set].respond_to?(:id)
          options[:widget_set].id
        else
          options[:widget_set]
        end
      else
        params[:widget_set] || nil
      end,
    :site => site(options)
    } ))
  end
  
  def widget_set_elements_url(options = {})
    widget_set_elements_path(options.merge({:only_path => false}))
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
