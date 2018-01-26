class CashImagesController < ApplicationController

  before_action :set_cashbox, except: [:index, :edit]
  before_action :set_cash_image, except: [:index, :create, :new]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    #authorize Cashbox

  end

  def show
    #authorize @cashbox
  end

  def new
    #authorize Cashbox
    @cash_image = @cashbox.cash_images.new
  end

  def edit
    #authorize @cashbox
  end

  def create
    #authorize Cashbox
    #binding.pry

    @cash_image = @cashbox.cash_images.build(permitted_attributes(CashImage))    # Not the final implementation!
    if @cash_image.save
      render 'shops/edit'
    else
      render 'new'
    end
  end

  def update
    #authorize @cashbox
    if @cash_image.update_attributes(permitted_attributes(@cash_image))
      #return redirect_back(fallback_location: root_path)

      redirect_to "#{edit_shop_path(@shop)}#panel2"

    else
      render 'edit'
    end
  end

  def destroy
    #authorize @cash_image
    if @cash_image.destroy
      flash[:success] = "Запись удачно удалена."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
      redirect_to cashboxs_path
  end


  private

  def set_cashbox
    @cashbox = Cashbox.find(params[:cashbox_id])
  end

  def set_cash_image
    @cash_image = CashImage.find(params[:id])
  end
end
