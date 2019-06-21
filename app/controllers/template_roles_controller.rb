class TemplateRolesController < ApplicationController
  before_action :set_template_role, only: [ :index, :new, :create, :update]
  before_action :set_role, only: [ :destroy, :edit]
  after_action :verify_authorized

  def show
    authorize @template_role
  end

  def new
    authorize TemplateRole
    @template_role = @role.template_role.build
  end

  def edit
    authorize @template_role
  end

  def create
    authorize TemplateRole
    @template_role = @role.template_role.create(permitted_attributes(TemplateRole))    # Not the final implementation!
    if @template_role.save
      redirect_to role_path(@role)
    else
      render 'new'
    end
  end

  def update
    authorize @template_role
    if @template_role.update_attributes(permitted_attributes(@template_role))
      redirect_to role_path(@role)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @template_role
    if @template_role.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to role_path(@role)
  end


  private

  def set_template_role
    @template_role = TemplateRole.find(params[:id])
    @role = @template_role.role
  end

  def set_role
    @role = Role.find(params[:role_id])
    @template_role = TemplateRole.find(params[:template_role_id])
  end
end
