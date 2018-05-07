class CommunicationsController < ApplicationController
  before_action :set_communication, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Communication
    @q = Communication.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @communications = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @communication
  end

  def new
    authorize Communication
    @communication = Communication.new
    set_new_edit_render
  end

  def edit
    authorize @communication
    set_new_edit_render
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

  def set_communication
    @communication = Communication.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @communications,
                      new_path: new_communication_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @communication,
           index_path: communications_path }
  end
end
