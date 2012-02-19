# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery

  # Checks whether authenticated or not.
  # If not authenticated,it redirects the browser to the login page.
  before_filter :checks_authenticated

  # Sets the current user for observing model updating.
  before_filter :set_current_user
  
  # Loads the current site and belongings.
  before_filter :load_current_site
  
  protected 
  
  # getting the sesstion of the current login user .
  # 現在ログインしているユーザセッション情報を得る
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  # getting the current login user (User model record) .
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  # getting the current site (Site model record) .
  def current_site
    load_current_site
    @site
  end

  # Checks whether authenticated or not.
  # If not authenticated,it redirects the browser to the login page.
  # 認証の確認.
  # 認証されていなければ、ログインページへのリダイレクト.
  # また、権限がなければ、権限エラーのページへリダイレクト.
  def checks_authenticated
    if can_skip_auth
      return true
    end
    
    if current_user.nil? 
      flash[:notice] = message(:user_sessions, :required_to_login)
      redirect_to :controller => '/user_sessions', :action => :new,
                  :back_uri => request.path_info
      return false
    end
    if self.class.need_admin(params[:action])
      render_404 and return unless current_user.is_admin
    elsif self.class.need_site_admin(params[:action])
      render_404 and return unless current_user.can_manage_site?(current_site)
    elsif self.class.need_editor(params[:action])
      render_404 and return unless current_user.can_edit_site?(current_site)
    end
    return true
  end
  
  # Renders the 404 (page which is not found) page.
  # It is rendered if 'public/404_<locale>.html' can be read. 
  # Otherwise, 'public/404.html' is displayed. 
  def render_404
    def path_for_404
      path = "#{::Rails.root.to_s}/public/404_#{I18n.locale.to_s}.html"  
      if File.readable?(path)
        path
      else
        "#{::Rails.root.to_s}/public/404.html"
      end
    end
    render :file => path_for_404, :status => 404
  end

  # Redirects the browser to the target specified by the  'back_uri request parameter
  # , Or the default url .   
  # = parameters
  # * defaut_uri 
  def redirect_back_or_default(defaut_uri  = 'sites')
    path = params[:back_uri] || defaut_uri 
    port = 
    if request.port.to_i == 80
      ''
    else
      ":#{request.port}"
    end
    redirect_to "#{request.protocol}#{request.host}#{port}#{path}"
  end

  def message(controller, key, options = {})
    I18n.t key, {:scope => [:controllers, controller, :messages]}.merge(options)
  end
  
  # whether the requested action can skip authorization.
  def can_skip_auth
    self.class.can_skip_auth(params[:action].to_sym)
  end

  protected
  

  private
  
  # Sets the current user for observing model updating.
  def set_current_user
    Observer::UserAction.instance.current_user = current_user
  end  
  
  # Enables auto login if required.
  def enables_auto_login_if_required
    if current_user
      if current_user.auto_login
        request.session_options[:expire_after] = 1.weeks
      else
        request.session_options[:expire_after] = nil
      end
    end
  end
  
  # Loads the current site and belongings.
  def load_current_site
    @site ||= 
    unless params[:site].blank? 
      if  (params[:site].is_a?(String) || params[:site].is_a?(Symbol))
        Site.find_by_name(params[:site])
      end
    end
    if @site
      @header_menu = @site.menus.by_menu_type(:header).first
    end
    @site
  end

  
  protected
  
  # skips authorization when actions requested.
  def self.skip_auth(*actions)
    @@auth_skipped_actions ||= {}
    @@auth_skipped_actions[self.name] ||= []
    actions.each do |action|
      @@auth_skipped_actions[self.name] << action.to_sym
    end
  end
  
  def self.site_admin_action(*actions)
    @@site_admin_actions ||= {}
    @@site_admin_actions[self.name] ||= []
    actions.each do |action|
      @@site_admin_actions[self.name] << action.to_sym
    end
  end

  def self.admin_action(*actions)
    @@admin_actions ||= {}
    @@admin_actions[self.name] ||= []
    actions.each do |action|
      @@admin_actions[self.name] << action.to_sym
    end
  end

  def self.editor_action(*actions)
    @@editor_actions ||= {}
    @@editor_actions[self.name] ||= []
    actions.each do |action|
      @@editor_actions[self.name] << action.to_sym
    end
  end

  def self.need_site_admin(action)
    @@site_admin_actions ||= {}
    return need_admin(action) if @@site_admin_actions[self.name].nil?
    @@site_admin_actions[self.name].include?(action.to_sym) 
  end

  def self.need_admin(action)
    @@admin_actions ||= {}
    return false if @@admin_actions[self.name].nil?
    @@admin_actions[self.name].include?(action.to_sym)
  end

  def self.need_editor(action)
    @@editor_actions ||= {}
    return need_site_admin(action) if @@editor_actions[self.name].nil?
    @@editor_actions[self.name].include?(action.to_sym)
  end
  
  # whether the  action can skip authorization.
  def self.can_skip_auth(action)
    @@auth_skipped_actions ||= {}
    return false if @@auth_skipped_actions.nil?
    return false if @@auth_skipped_actions[self.name].nil?
    @@auth_skipped_actions[self.name].include?(action.to_sym)
  end
  
end

