class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @member = Member.find(params[:member_id])
    @memberships = collection.order(:year)
    @membership = collection.build
  end

  def create
    @membership = collection.create(membership_params)
    if @membership.valid?
      redirect_to action: 'index'
    else
      render action: 'index'
    end
  end

  def update
    @membership = collection.update(params[:id], membership_params)
    if @membership.valid?
      redirect_to action: 'index'
    else
      render action: 'index'
    end
  end

  def destroy
    collection.destroy(params[:id])
    redirect_to action: 'index'
  end

  protected

  def collection
    Membership.where(member_id: params[:member_id])
  end

  def membership_params
    unless @member_params
      @member_params = params.require(:membership)
      @member_params = @member_params.permit(:year)
    end
    @member_params
  end

end
