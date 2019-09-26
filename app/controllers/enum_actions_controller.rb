class EnumActionsController < ApplicationController
  before_action :set_enum_action, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize EnumAction
    @q = EnumAction.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @enum_actions = @q.result(disinct: true)
  end

  def show
    authorize @enum_action
  end

  def new
    authorize EnumAction
    @enum_action = EnumAction.new
  end

  def edit
    authorize @enum_action
  end

  def create
    authorize EnumAction
    @enum_action = EnumAction.new(permitted_attributes(EnumAction))    # Not the final implementation!
    if @enum_action.save
      redirect_to enum_actions_path
    else
      render 'new'
    end
  end

  def update
    authorize @enum_action
    if @enum_action.update_attributes(permitted_attributes(@enum_action))
      redirect_to enum_actions_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @enum_action
    if @enum_action.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to enum_actions_path
  end


  private

  def set_enum_action
    @enum_action = EnumAction.find(params[:id])
  end
end
