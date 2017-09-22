class PositionsController < ApplicationController

  before_action :set_position, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Position
    @q = Position.ransack(params[:q])
    @positions = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @position
  end

  def new
    authorize Position
    @position = Position.new
  end

  def edit
    authorize @position
  end

  def create
    authorize Position
    @position = Position.new(permitted_attributes(Position))    # Not the final implementation!
    if @position.save
      redirect_to positions_path
    else
      render 'new'
    end
  end

  def update
    authorize @position
    if @position.update_attributes(permitted_attributes(@position))
     redirect_to positions_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @position
    if @position.destroy
      flash[:success] = "Должность удачно удален."
      redirect_to positions_path
    else
      flash[:error] = "Должность не может буть удален. Есть связанные данные"
    end
  end


  private

  def set_position
    @position = Position.find(params[:id])
  end
end
