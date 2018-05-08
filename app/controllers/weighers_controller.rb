class WeighersController < ApplicationController
  before_action :set_weigher, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Weigher
    @q = Weigher.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @weighers = @q.result(disinct: true)
    set_index_render(@q, @weighers, new_weigher_path)
  end

  def show
    authorize @weigher
  end

  def new
    authorize Weigher
    @weigher = Weigher.new
    set_new_edit_render(@weigher, weighers_path)
  end

  def edit
    authorize @weigher
    set_new_edit_render(@weigher, weighers_path)
  end

  def create
    authorize Weigher
    @weigher = Weigher.new(permitted_attributes(Weigher))    # Not the final implementation!
    if @weigher.save
      redirect_to weighers_path
    else
      render 'new'
    end
  end

  def update
    authorize @weigher
    if @weigher.update_attributes(permitted_attributes(@weigher))
     redirect_to weighers_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @weigher
    if @weigher.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to weighers_path
  end


  private

  def set_weigher
    @weigher = Weigher.find(params[:id])
  end
end
