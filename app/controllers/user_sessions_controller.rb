# = UserSessionController
# controlling login.
class UserSessionsController < ApplicationController

  skip_filter :checks_authenticated

  # GET user_sessions
  # displaying the login page.
  def new
    @user_session = UserSession.new
  end

  # POST user_sessions
  # Completion of login. 
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.auto_login = params[:user][:auto_login]
      @user_session.user.save!(:validate => false)
      redirect_back_or_default 'sites', 'index'
    else
      render :action => :new
    end
  end
  
  # DELETE user_sessions
  def destroy
    if current_user_session
      current_user_session.destroy
    end
    redirect_to :controller => :user_sessions, :action => :new
  end

  protected
  

end
