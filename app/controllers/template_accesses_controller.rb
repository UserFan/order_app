class TemplateAccessesController < ApplicationController
  before_action :set_template_access, only: [ :index, :new, :create, :update]
  before_action :set_role, only: [ :destroy, :edit]
  after_action :verify_authorized

  def show
    authorize @template_access
  end

  def new
    authorize TemplateAccess
    @template_access = @role.template_role.build
  end

  def edit
    authorize @template_access
  end

  def create
    authorize TemplateAccess
    @template_access = @role.template_role.create(permitted_attributes(TemplateAccess))    # Not the final implementation!
    if @template_access.save
      redirect_to role_path(@role)
    else
      render 'new'
    end
  end

  def update
    authorize @template_access
    if @template_access.update_attributes(permitted_attributes(@template_access))
      redirect_to role_path(@role)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @template_access
    if @template_access.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to role_path(@role)
  end


  private

  def set_template_access
    @template_access = TemplateAccess.find(params[:id])
    @role = @template_access.role
  end

  def set_role
    @role = Role.find(params[:role_id])
    @template_access = TemplateAccess.find(params[:template_role_id])
  end
end
