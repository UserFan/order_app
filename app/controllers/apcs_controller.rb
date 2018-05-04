class ApcsController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Apc
    @q = Apc.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @apcs = @q.result(disinct: true)
  end

  def show
    authorize @apc
  end

  def new
    authorize Apc
    @apc = Apc.new
  end

  def edit
    authorize @apc
  end

  def create
    authorize Apc
    @apc = Apc.new(permitted_attributes(Apc))    # Not the final implementation!
    if @apc.save
      redirect_to apcs_path
    else
      render 'new'
    end
  end

  def update
    authorize @apc
    if @apc.update_attributes(permitted_attributes(@apc))
      redirect_to apcs_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @apc
    if @apc.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to apcs_path
  end


  private

  def set_type
    @apc = Apc.find(params[:id])
  end
end
