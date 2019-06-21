class RolesController < ApplicationController
  before_action :set_role, except: [:index ]
  after_action :verify_authorized

  def index
    authorize Role
    @q = Role.includes(:template_roles).ransack(params[:q])
    @q.sorts = ['date_end_esp desc', 'created_at desc'] if @q.sorts.empty?
    @roles = @q.result(disinct: true)
  end


  def new
    authorize Role
    @role = Role.new
  end

  def edit
    authorize @role
  end

  def show
    authorize @role
    @template_roles = @role.template_roles
    action_names = ActionName.all
    action_names.each do |action_name|
      unless @template_roles.present?
        @role.template_roles.create!(role_id: @role.id,
                                     action_name_id: action_name.id,
                                     type_access: 200,
                                     name: @role.name)
      else
        @role.template_roles.create!(role_id: @role.id,
          action_name_id: action_name.id, type_access: 200,
          name: @role.name) unless @template_roles.find_by(role_id: @role.id, action_name_id: action_name)
      end
    end
  end

  def create
    authorize Role
    @role = Role.create(permitted_attributes(Role))
    if @role.save
      #@role.template_roles.any?
      redirect_to roles_path
    else
      render 'new'
    end
  end

  def update
    authorize @role
    if @role.update_attributes(permitted_attributes(@role))
     redirect_to roles_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @role
    if @role.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to roles_path
  end

  def export_xls
    authorize Role
    @esp_xls = Role.includes(:shop, :esp).order('shops.name asc')
    respond_to do |format|
      format.xlsx {
        render xlsx: "export_xls", filename: "esp_all.xlsx"
        }
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end
end
