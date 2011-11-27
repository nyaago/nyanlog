module FoldersHelper
  
  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else nil end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end

  def folder_path(folder, options = {})
    url_for(options.merge({
    :action => 
      if options[:action].blank? 
        if params[:action] == 'edit' ||  params[:action] == 'update'
          'update'
        elsif params[:action] == 'new' ||  params[:action] == 'create'
          'create'
        elsif params[:action] == 'show' 
          'show'
        else
          'index' 
        end
      else 
        options[:action] 
      end,
    :controller => 'folders',
    :site => site(options) || if folder;folder.name;end,
    :name => 
      if folder.nil? 
        params[:name] 
      else
        if folder.respond_to?(:name)  # Folder model record
          unless folder.new_record?
            folder.name 
          end
        else  # 
          folder 
        end 
      end}
      ))
  end
  
  def folder_url(folder, options = {})
    folder_path(folder, options.merge({:only_path => false}))
  end
  
  def new_folder_path(options = {})
    url_for(options.merge( {
    :controller => 'folders',
    :action => :new,
    :site => site(options)
    } ))
  end

  def new_folder_url(options = {})
    new_folder_path(options.merge({:only_path => false}))
  end


  def edit_folder_path(folder,options = {})
    url_for(options.merge( {
    :controller => 'folders',
    :action => :edit,
    :name => 
      if folder.nil? 
        params[:name] 
      else
        if folder.respond_to?(:name) 
          folder.name 
        else 
          folder 
        end 
      end,
    :site => site(options)
    } ))
  end
  
  def edit_folder_url(folder, options = {})
    edit_folder_path(folder, options.merge({:only_path => false}))
  end
  

  def folders_path(options = {})
    url_for(options.merge( {
    :controller => 'folders',
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
  
  def folders_url(options = {})
    folders_path(options.merge({:only_path => false}))
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
