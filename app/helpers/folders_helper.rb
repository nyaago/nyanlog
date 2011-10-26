module FoldersHelper
  
  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else 1 end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end

  def folder_path(folder, options = {})
    url_for(options.merge({:action => 
    if options[:action].blank? 
      if params[:action] == 'edit' ||  params[:action] == 'update'
        'update'
      elsif params[:action] == 'show' 
        'show'
      else
        'update' 
      end
    else 
      options[:action] 
    end, 
    :site => site(options),
    :name => 
      if folder.nil? then params[:name] else
        if folder.respond_to?(:name) then  folder.name else folder 
        end 
      end}
      ))
  end
  
  def new_folder_path(options = {})
    url_for(options.merge( {
    :action => :new,
    :site => site(options)
    } ))
  end

  def edit_folder_path(folder,options = {})
    url_for(options.merge( {
    :action => :edit,
    :name => 
      if folder.nil? then params[:name] else
        if folder.respond_to?(:name) then  folder.name else folder 
        end 
      end,
    :site => site(options)
    } ))
  end

  def folders_path(options = {})
    url_for(options.merge( {
    :action =>
    if options[:action].blank? 
      if params[:action] == 'new' || params[:action] == 'create'
        'create'
      else
        'list' 
      end
    else 
      options[:action] 
    end, 
    :site => site(options)
    } ))
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
