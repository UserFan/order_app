class RoutersController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Router
    @q =Router.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @routers = @q.result(disinct: true)
  end

  def show
    authorize @router
  end

  def new
    authorize Router
    @router = Router.new
  end

  def edit
    authorize @router
  end

  def create
    authorize Router
    @router = Router.new(permitted_attributes(Router))    # Not the final implementation!
    if @router.save
      redirect_to routers_path
    else
      render 'new'
    end
  end

  def update
    authorize @router
    if @router.update_attributes(permitted_attributes(@router))
     redirect_to routers_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @router
    if @router.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to routers_path
  end


  private

  def set_type
    @router = Router.find(params[:id])
  end
end
