class UsersController < ApplicationController
  #before_action :require_local!
  before_action :authenticate_user!
  before_action :authorize_action!

  def index
    if current_user.super
      @users = User.all
    else
      @users = User.where(id: current_user.id)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      redirect_to @user
    else
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.update(params[:id], user_params)
    if @user.valid?
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  def destroy
    User.destroy(params[:id])
    redirect_to action: 'index'
  end

  private

  def allowed_attributes
    unless defined? @allowed_attributes
      attribs = %i(login email password password_confirmation)
      attribs << 'super' if current_user.super
      @allowed_attributes = attribs
    end
    @allowed_attributes
  end

  def user_params
    unless @user_params
      @user_params = params.require(:user)
      @user_params = @user_params.permit(*allowed_attributes)
    end
    @user_params
  end

  def authorize_action!
    case action_name
    when /new|create/
      authorize_super_user!
    when /show|edit|update|delete/
      puts current_user.inspect
      authorize_super_user! if params[:id] != current_user.id.to_s
    end
  end

end
