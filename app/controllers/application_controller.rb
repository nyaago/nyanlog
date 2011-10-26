# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery

  # Checks whether authenticated or not.
  # If not authenticated,it redirects the browser to the login page.
  before_filter :checks_authenticated

  # Sets the current user for observing model updating.
  before_filter :set_current_user
  
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

  # Checks whether authenticated or not.
  # If not authenticated,it redirects the browser to the login page.
  # 認証の確認.
  # 認証されていなければ、ログインページへのリダイレクト.
  # また、権限がなければ、権限エラーのページへリダイレクト.
  def checks_authenticated
    if current_user.nil? 
      flash[:notice] = message(:user_sessions, :required_to_login)
      redirect_to :controller => '/user_sessions', :action => :new,
                  :back_controller => params[:controller]
      return false
    end
    return true
  end

  # Redirects the browser to the target specified by the  'back_controller' request parameter
  # and the 'back_action' request parameter, Or the target specified by  arguments.   
  # = parameters
  # * defaut_controller - The controller name used 
  # when the parameter 'back_controller' is not included in request parameters.
  # * defaut_action - The action name used 
  # when the parameter 'back_action' is not included in request parameters.
  def redirect_back_or_default(default_controller, default_action = :index)
    redirect_to(:controller =>  
                      if params[:back_controller].blank? 
                        default_controller
                      else
                        params[:back_controller]
                      end,
                :action => 
                      if params[:back_action].blank? 
                        default_action
                      else
                        params[:back_action]
                      end)
  end

  def message(controller, key, options = {})
    I18n.t key, {:scope => [:controllers, controller, :messages]}.merge(options)
  end

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
  
end
