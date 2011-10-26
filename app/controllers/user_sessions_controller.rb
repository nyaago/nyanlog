# = UserSessionController
# controlling login.
class UserSessionsController < ApplicationController

  skip_filter :checks_authenticated

  # GET user_session
  # displaying the login page.
  def new
    @user_session = UserSession.new
  end

  # POST user_session/create
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

  protected
  

end
