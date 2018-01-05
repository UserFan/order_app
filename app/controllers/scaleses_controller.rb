class ScalesesController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Scales
    @q = Scales.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @scaleses = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @scales
  end

  def new
    authorize Scales
    @scales = Scales.new
  end

  def edit
    authorize @scales
  end

  def create
    authorize Scales
    @scales = Scales.new(permitted_attributes(Scales))    # Not the final implementation!
    if @scales.save
      redirect_to scaleses_path
    else
      render 'new'
    end
  end

  def update
    authorize @scales
    if @scales.update_attributes(permitted_attributes(@scales))
     redirect_to scaleses_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @scales
    if @scales.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to scaleses_path
  end


  private

  def set_type
    @scales = Scales.find(params[:id])
  end
end
