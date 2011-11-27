module MenuItemsHelper
  
  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else nil end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end

  def menu_item_path(menu_item, options = {})
    url_for(options.merge({
    :controller => :menu_items,
    :action => 
      if options[:action].blank? 
        if params[:action] == 'edit' ||  params[:action] == 'update'
          'update'
        elsif params[:action] == 'new' ||  params[:action] == 'create'
          'create'
        elsif params[:action] == 'show' 
          'show'
        else
          'update' 
        end
      else 
        options[:action] 
      end,
    :site => site(options),
    :id => 
      if menu_item.nil? 
        params[:id] 
      else
        if menu_item.respond_to?(:id)   # Article model record
          unless menu_item.new_record?
            menu_item.id 
          end
        else 
          menu_item 
        end 
      end}
      ))
  end
  
  def menu_item_url(menu_item, options = {})
    menu_item_path(menu_item, options.merge({:only_path => false}))
  end
  
  def new_menu_item_path(options = {})
    url_for(options.merge( {
    :controller => :menu_items,
    :action => :new,
    :site => site(options)
    } ))
  end
  
  def new_menu_item_url(options = {})
    menu_item_url(options.merge({:only_path => false}))
  end

  def edit_menu_item_path(menu_item,options = {})
    url_for(options.merge( {
    :controller => :menu_items,
    :action => :edit,
    :id => 
      if menu_item.nil? 
        params[:id] 
      else
        if menu_item.respond_to?(:id) # Article model record
          menu_item.id 
        else 
          menu_item 
        end 
      end,
    :site => site(options)
    } ))
  end

  def menu_items_path(options = {})
    url_for(options.merge( {
    :controller => :menu_items,
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
    }.merge(url_options_from_params) ))
  end

  def menu_items_url(options = {})
    menu_item_path(options.merge({:only_path => false}))
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
