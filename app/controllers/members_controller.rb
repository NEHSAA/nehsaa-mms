class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    @members = Member.all.includes(:memberships)
    @member_grid = initialize_grid(@members)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.create(member_params)
    if @member.valid?
      redirect_to action: 'show', id: @member.id
    else
      render action: 'new'
    end
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.update(params[:id], member_params)
    if @member.valid?
      redirect_to action: 'show', id: @member.id
    else
      render action: 'edit'
    end
  end

  def destroy
    Member.destroy(params[:id])
    redirect_to action: 'index'
  end

  def moi_sheet
    @members = Member.all
  end

  def email_list
    @members = Member.all
  end

  private

  def allowed_attributes
    unless defined? @allowed_attributes
      attribs = %i(name security_id birthdate gender
      occupation company education
      address facebook
      grad_class grad_year grad_id grad_department)
      attribs += %i(member_type permanent) # TODO: permission?
      attribs << { emails: [] }
      attribs << { phones: [] }
      @allowed_attributes = attribs
    end
    @allowed_attributes
  end

  def member_params
    unless @member_params
      @member_params = params.require(:member)
      @member_params = @member_params.permit(*allowed_attributes)
    end
    @member_params
  end

end
