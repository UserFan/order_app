class PagesController < ApplicationController

  after_action :verify_authorized

  def home
    authorize :pages, :home?
    date_start = DateTime.now.beginning_of_month
    date_end = DateTime.now.end_of_month
    @esp_count = EspCert.includes(:carrier_type).where('date_end_esp >= ?' 'and date_end_esp <= ?', date_start, date_end).size
    @rsa_count = EspCert.includes(:carrier_type).where('date_end_rsa >= ?' 'and date_end_rsa <= ?', date_start, date_end).size
  end

  def catalog
    authorize :pages, :catalog?

  end
end
