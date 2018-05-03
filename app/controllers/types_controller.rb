class TypesController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Type
    @q =Type.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @types = @q.result(disinct: true)
    render layout: "catalogs"
    #@positions = Position.all
  end

  def show
    authorize @type
  end

  def new
    authorize Type
    @type = Type.new
  end

  def edit
    authorize @type
  end

  def create
    authorize Type
    @type = Type.new(permitted_attributes(Type))    # Not the final implementation!
    if @type.save
      redirect_to types_path
    else
      render 'new'
    end
  end

  def update
    authorize @type
    if @type.update_attributes(permitted_attributes(@type))
     redirect_to types_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @type
    if @type.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to types_path
  end


  private

  def set_type
    @type = Type.find(params[:id])
  end
end
