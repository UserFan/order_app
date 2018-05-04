class FiscalsController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Fiscal
    @q =Fiscal.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @fiscals = @q.result(disinct: true)
  end

  def show
    authorize @fiscal
  end

  def new
    authorize Fiscal
    @fiscal = Fiscal.new
  end

  def edit
    authorize @fiscal
  end

  def create
    authorize Fiscal
    @fiscal = Fiscal.new(permitted_attributes(Fiscal))    # Not the final implementation!
    if @fiscal.save
      redirect_to fiscals_path
    else
      render 'new'
    end
  end

  def update
    authorize @fiscal
    if @fiscal.update_attributes(permitted_attributes(@fiscal))
     redirect_to fiscals_path
    else
      render :edit
    end
  end

  def destroy
    authorize @fiscal
    if @fiscal.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to fiscals_path
  end


  private

  def set_type
    @fiscal = Fiscal.find(params[:id])
  end
end
