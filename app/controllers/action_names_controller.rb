class ActionNamesController < ApplicationController
  before_action :set_action_name, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize ActionName
    @q = ActionName.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @action_names = @q.result(disinct: true)
  end

  def show
    authorize @action_name
  end

  def new
    authorize ActionName
    @action_name = ActionName.new
  end

  def edit
    authorize @action_name
  end

  def create
    authorize ActionName
    @action_name = ActionName.new(permitted_attributes(ActionName))    # Not the final implementation!
    if @action_name.save
      redirect_to action_names_path
    else
      render 'new'
    end
  end

  def update
    authorize @action_name
    if @action_name.update_attributes(permitted_attributes(@action_name))
      redirect_to action_names_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @action_name
    if @action_name.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to action_names_path
  end


  private

  def set_action_name
    @action_name = ActionName.find(params[:id])
  end
end
