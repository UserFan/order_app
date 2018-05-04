class ScanersController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Scaner
    @q =Scaner.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @scaners = @q.result(disinct: true)
  end

  def show
    authorize @scaner
  end

  def new
    authorize Scaner
    @scaner = Scaner.new
  end

  def edit
    authorize @scaner
  end

  def create
    authorize Scaner
    @scaner = Scaner.new(permitted_attributes(Scaner))    # Not the final implementation!
    if @scaner.save
      redirect_to scaners_path
    else
      render 'new'
    end
  end

  def update
    authorize @scaner
    if @scaner.update_attributes(permitted_attributes(@scaner))
     redirect_to scaners_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @scaner
    if @scaner.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to scaners_path
  end


  private

  def set_type
    @scaner = Scaner.find(params[:id])
  end
end
