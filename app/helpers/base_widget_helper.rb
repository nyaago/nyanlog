module BaseWidgetHelper
  
  # 
  # Returns the array of pairs of the folder title and the folder id.
  # This method is used as the parameter of  'select' form helper methods.
  # ex. select(:folder, selectable_folder_pair)
  def selectable_folder_pair
    [[human_attribute_value(:widget, :folder, :viewed), nil]] + 
    @site.folders.can_manage_for(@current_user).collect {|folder| [folder.title, folder.id]}
  end

  AppConfig::Widget.array.each do |widget|
    define_method("#{widget.name}_path" , 
    Proc.new do |record, options|
      url_for(options.merge( {
      :controller => widget.name,
      :action => 
        if options[:action].blank? 
          if params[:action] == 'new' ||  params[:action] == 'create'
            'create'
          elsif params[:action] == 'show' 
            'show'
          elsif params[:action] == 'index' 
            'index'
          elsif params[:action] == 'edit' 
            'update' 
          end
        else 
          options[:action] 
        end,
      :site => site(options)
      } ) )
      
    end
    )  
    
    
  end

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


