class ScanersController < ApplicationController
  before_action :set_scaner, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Scaner
    @q =Scaner.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @scaners = @q.result(disinct: true)
    set_index_render(@q, @scaners, new_scaner_path)
  end

  def show
    authorize @scaner
  end

  def new
    authorize Scaner
    @scaner = Scaner.new
    set_new_edit_render(@scaner, scaners_path)
  end

  def edit
    authorize @scaner
    set_new_edit_render(@scaner, scaners_path)
  end

  def create
    authorize Scaner
    @scaner = Scaner.new(permitted_attributes(Scaner))    # Not the final implementation!
    if @scaner.save
      redirect_to scaners_path
    else
      render 'new'
    end
  end

  def update
    authorize @scaner
    if @scaner.update_attributes(permitted_attributes(@scaner))
     redirect_to scaners_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @scaner
    if @scaner.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to scaners_path
  end


  private

  def set_scaner
    @scaner = Scaner.find(params[:id])
  end
end
