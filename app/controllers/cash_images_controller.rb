class CashImagesController < ApplicationController

  before_action :set_cashbox_image, except: [:index ]
  before_action :authenticate_user!
  after_action :verify_authorized



  def show
    authorize @cash_image
    
  end

  private

  def set_cashbox_image
    @cash_image = CashImage.find(params[:id])
  end
end
