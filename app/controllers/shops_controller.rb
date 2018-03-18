class ShopsController < ApplicationController

  before_action :set_shop, except: [:index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Shop
    @q = Shop.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @shops = @q.result(disinct: true)
    @shops_closed = Shop.ransack(closed_not_null: '1').result.count
    @shops_open = Shop.ransack(closed_not_null: '0').result.count
    @shops_count = Shop.count
  end

  def show
    authorize @shop
  end

  def new
    authorize Shop
    @shop = Shop.new
  end

  def edit
    authorize @shop
  end

  def create
    authorize Shop
    @shop = Shop.new(permitted_attributes(Shop))    # Not the final implementation!
    if @shop.save
      redirect_to shops_path
    else
      render 'new'
    end

  end

  def update
    authorize @shop
    if @shop.update_attributes(permitted_attributes(@shop))
      redirect_to shops_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @shop
    if @shop.destroy
      flash[:success] = "Торговый объект удачно удален."
    else
      flash[:error] = "Торговый объект не может буть удален. Есть связанные данные"
    end
    redirect_to shops_path
  end


  private

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
