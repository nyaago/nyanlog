module ArticlesHelper
  
  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else 1 end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end

  def article_path(article, options = {})
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
    :folder => folder(options),
    :id => 
      if article.nil? then params[:id] else
        if article.respond_to?(:id) then  article.id else article 
        end 
      end}
      ))
  end
  
  def new_article_path(options = {})
    url_for(options.merge( {
    :action => :new,
    :site => site(options),
    :folder => folder(options)
    } ))
  end

  def edit_article_path(article,options = {})
    url_for(options.merge( {
    :action => :edit,
    :id => 
      if article.nil? then params[:id] else
        if article.respond_to?(:id) then  article.id else article 
        end 
      end,
    :site => site(options),
    :folder => folder(options)
    } ))
  end

  def articles_path(options = {})
    url_for(options.merge( {
    :controller => :articles,
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
    :site => site(options),
    :folder => folder(options)
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
