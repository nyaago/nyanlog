module ImagesHelper
  
  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else nil end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end

  def image_path(image, options = {})
    url_for(options.merge({
    :controller => :images,
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
    :folder => folder(options),
    :id => 
      if image.nil? 
        params[:id] 
      else
        if image.respond_to?(:id)   # Article model record
          unless image.new_record?
            image.id 
          end
        else 
          image 
        end 
      end}
      ))
  end
  
  def image_url(image, options = {})
    image_path(image, options.merge({:only_path => false}))
  end
  
  def new_image_path(options = {})
    url_for(options.merge( {
    :controller => :images,
    :action => :new,
    :site => site(options),
    :folder => folder(options)
    } ))
  end
  
  def new_image_url(options = {})
    image_url(options.merge({:only_path => false}))
  end

  def edit_image_path(image,options = {})
    url_for(options.merge( {
    :controller => :images,
    :action => :edit,
    :id => 
      if image.nil? 
        params[:id] 
      else
        if image.respond_to?(:id) # Article model record
          image.id 
        else 
          image 
        end 
      end,
    :site => site(options),
    :folder => folder(options)
    } ))
  end

  def images_path(options = {})
    url_for(options.merge( {
    :controller => :images,
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
    :site => site(options),
    :folder => folder(options)
    }.merge(url_options_from_params) ))
  end

  def images_url(options = {})
    image_path(options.merge({:only_path => false}))
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
  
  def folder(options)
    folder = options[:folder]
    if folder.nil? 
      params[:folder]
    else
      if folder.respond_to?(:name) 
        folder.name 
      else 
        folder
      end
    end
  end
  
end
