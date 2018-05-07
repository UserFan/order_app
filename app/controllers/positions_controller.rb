class PositionsController < ApplicationController
  before_action :set_position, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Position
    @q = Position.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @positions = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @position
  end

  def new
    authorize Position
    @position = Position.new
    set_new_edit_render
  end

  def edit
    authorize @position
    set_new_edit_render
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
    else
      flash[:error] = "Должность не может буть удален. Есть связанные данные"
    end
    redirect_to positions_path
  end


  private

  def set_position
    @position = Position.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @positions,
                      new_path: new_position_path } and return
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @position,
           index_path: positions_path }
  end

end
