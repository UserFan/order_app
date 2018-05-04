class CommunicationsController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Communication
    @q = Communication.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @communications = @q.result(disinct: true)  
  end

  def show
    authorize @communication
  end

  def new
    authorize Communication
    @communication = Communication.new
  end

  def edit
    authorize @communication
  end

  def create
    authorize Communication
    @communication = Communication.new(permitted_attributes(Communication))    # Not the final implementation!
    if @communication.save
      redirect_to communications_path
    else
      render 'new'
    end
  end

  def update
    authorize @communication
    if @communication.update_attributes(permitted_attributes(@communication))
     redirect_to communications_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @communication
    if @communication.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to communications_path
  end


  private

  def set_type
    @communication = Communication.find(params[:id])
  end
end
