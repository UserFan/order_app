class StabilizersController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Stabilizer
    @q =Stabilizer.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @stabilizers = @q.result(disinct: true)
    render layout: "catalogs"
    #@positions = Position.all
  end

  def show
    authorize @stabilizer
  end

  def new
    authorize Stabilizer
    @stabilizer = Stabilizer.new
  end

  def edit
    authorize @stabilizer
  end

  def create
    authorize Stabilizer
    @stabilizer = Stabilizer.new(permitted_attributes(Stabilizer))    # Not the final implementation!
    if @stabilizer.save
      redirect_to stabilizers_path
    else
      render 'new'
    end
  end

  def update
    authorize @stabilizer
    if @stabilizer.update_attributes(permitted_attributes(@stabilizer))
     redirect_to stabilizers_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @stabilizer
    if @stabilizer.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to stabilizers_path
  end


  private

  def set_type
    @stabilizer = Stabilizer.find(params[:id])
  end
end
