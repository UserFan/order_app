class CashboxesController < ApplicationController

  before_action :set_shop, except: [:index]
  before_action :set_cashbox, except: [:index, :create, :new]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Cashbox

  end

  def show
    authorize @cashbox
  end

  def new
    authorize Cashbox
    @cashbox = @shop.cashboxes.new
  end

  def edit
    authorize @cashbox
  end

  def create
    authorize Cashbox
    #binding.pry

    @cashbox = @shop.cashboxes.build(permitted_attributes(Cashbox))    # Not the final implementation!
    if @cashbox.save
      redirect_to @shop
    else
      render 'new'
    end
  end

  def update
    authorize @cashbox
    if @cashbox.update_attributes(permitted_attributes(@cashbox))
     redirect_to @shop
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
    @shop = Shop.find(params[:shop_id])
  end

  def set_cashbox
    @cashbox = @shop.cashboxes.find(params[:id])
  end
end
