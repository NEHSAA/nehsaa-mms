class WelcomeController < ApplicationController

  def index
  end

  def about
  end

  def search_member
    sid = params[:security_id]
    redirect_to action: :index and return if sid.blank?
    @member = Member.where(security_id: sid).first
    if @member
      redirect_to member_path(@member)
    else
      redirect_to new_member_path
    end
  end

end
