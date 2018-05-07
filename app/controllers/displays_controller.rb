class DisplaysController < ApplicationController
  before_action :set_display, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Display
    @q = Display.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @displays = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @display
  end

  def new
    authorize Display
    @display = Display.new
    set_new_edit_render
  end

  def edit
    authorize @display
    set_new_edit_render
  end

  def create
    authorize Display
    @display = Display.new(permitted_attributes(Display))    # Not the final implementation!
    if @display.save
      redirect_to displays_path
    else
      render 'new'
    end
  end

  def update
    authorize @display
    if @display.update_attributes(permitted_attributes(@display))
     redirect_to displays_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @display
    if @display.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to displays_path
  end


  private

  def set_display
    @display = Display.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @displays,
                      new_path: new_display_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @display,
           index_path: displays_path }
  end
end
