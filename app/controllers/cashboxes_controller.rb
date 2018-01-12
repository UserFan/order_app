class CashboxesController < ApplicationController

  before_action :set_shop, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Cashbox
    @q = Cashbox.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @cashboxes = @q.result(disinct: true)
  end

  def show
    authorize @cashbox
  end

  def new
    authorize Cashbox
    @cashbox = Cashbox.new
  end

  def edit
    authorize @cashbox
  end

  def create
    authorize Cashbox
    @cashbox = Cashbox.new(permitted_attributes(Cashbox))    # Not the final implementation!
    if @cashbox.save
      redirect_to cashboxs_path
    else
      render 'new'
    end
  end

  def update
    authorize @cashbox
    if @cashbox.update_attributes(permitted_attributes(@cashbox))
     redirect_to cashboxs_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @cashbox
    if @cashbox.destroy
      flash[:success] = "Запись удачно удалена."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to cashboxs_path
  end


  private

  def set_shop
    @cashbox = Cashbox.find(params[:id])
  end
end
