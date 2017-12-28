class ModemsController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Modem
    @q = Modem.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @modems = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @modem
  end

  def new
    authorize Modem
    @modem = Modem.new
  end

  def edit
    authorize @modem
  end

  def create
    authorize Modem
    @modem = Modem.new(permitted_attributes(Modem))    # Not the final implementation!
    if @modem.save
      redirect_to modems_path
    else
      render 'new'
    end
  end

  def update
    authorize @modem
    if @modem.update_attributes(permitted_attributes(@modem))
     redirect_to modems_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @modem
    if @modem.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to modems_path
  end


  private

  def set_type
    @modem = Modem.find(params[:id])
  end
end
