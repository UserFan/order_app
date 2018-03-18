class PagesController < ApplicationController
  after_action :verify_authorized

  def home
    authorize :pages, :home?
  end

  def catalog
    authorize :pages, :catalog?
  end
end
