class CommousesController < ApplicationController
  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Commouse
    @q = Commouse.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @commouses = @q.result(disinct: true)
    render layout: "catalogs"
    #@positions = Position.all
  end

  def show
    authorize @commouse
  end

  def new
    authorize Commouse
    @commouse = Commouse.new
  end

  def edit
    authorize @commouse
  end

  def create
    authorize Commouse
    @commouse = Commouse.new(permitted_attributes(Commouse))    # Not the final implementation!
    if @commouse.save
      redirect_to commouses_path
    else
      render 'new'
    end
  end

  def update
    authorize @commouse
    if @commouse.update_attributes(permitted_attributes(@commouse))
     redirect_to commouses_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @commouse
    if @commouse.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to commouses_path
  end


  private

  def set_type
    @commouse = Commouse.find(params[:id])
  end
end
