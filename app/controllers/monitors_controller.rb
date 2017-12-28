class MonitorsController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Monitor
    @q = Monitor.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @monitors = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @monitor
  end

  def new
    authorize Monitor
    @monitor = Monitor.new
  end

  def edit
    authorize @monitor
  end

  def create
    authorize Monitor
    @monitor = Monitor.new(permitted_attributes(Monitor))    # Not the final implementation!
    if @monitor.save
      redirect_to monitors_path
    else
      render 'new'
    end
  end

  def update
    authorize @monitor
    if @monitor.update_attributes(permitted_attributes(@monitor))
     redirect_to monitors_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @monitor
    if @monitor.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to monitors_path
  end


  private

  def set_type
    @monitor = Monitor.find(params[:id])
  end
end
