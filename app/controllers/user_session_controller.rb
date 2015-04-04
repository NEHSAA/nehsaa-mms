class UserSessionController < ApplicationController

  def new
    redirect_to(:root) and return if user_signed_in?
    @user_session = UserSession.new
  end

  def create
    redirect_to(:root) and return if user_signed_in?
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :root
    else
      render action: :new
    end
  end

  def destroy
    current_user_session.destroy if user_signed_in?
    redirect_to :root
  end

end
