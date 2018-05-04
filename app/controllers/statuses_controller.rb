class StatusesController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_status, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Status
    @q = Status.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @statuses = @q.result(disinct: true)
  end

  def show
    authorize @status
  end

  def new
    authorize Status
    @status = Status.new
  end

  def edit
    authorize @status
  end

  def create
    authorize Status
    @status = Status.new(permitted_attributes(Status))    # Not the final implementation!
    if @status.save
      redirect_to statuses_path
    else
      render 'new'
    end
  end

  def update
    authorize @status
    if @status.update_attributes(permitted_attributes(@status))
     redirect_to statuses_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @status
    if @status.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to statuses_path
  end


  private

  def set_status
    @status = Status.find(params[:id])
  end
end
