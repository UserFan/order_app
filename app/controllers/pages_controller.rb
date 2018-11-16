class PagesController < ApplicationController

  after_action :verify_authorized

  def home
    authorize :pages, :home?
    date_start = Date.today.beginning_of_month
    date_end = Date.today.end_of_month
    @esp_count = EspCert.includes(:shop, :esp).where(date_end_esp: date_start..date_end).size
    @rsa_count = EspCert.includes(:shop, :esp).where(date_end_rsa: date_start..date_end).size
  end

  def catalog
    authorize :pages, :catalog?

  end
end
