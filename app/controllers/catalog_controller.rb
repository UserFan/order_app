class CatalogController < ApplicationController
  before_action :catalog_model_name
  before_action :set_val, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize @catalog_model
    @q = @catalog_model.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @catalog_collections = @q.result(disinct: true)
    set_index_render(@q, @catalog_collections)
  end

  def show
    authorize @catalog_collection
  end

  def new
    authorize @catalog_model
    @catalog_collection = @catalog_model.new
    set_new_edit_render(@catalog_collection)
  end

  def edit
    authorize @catalog_collection
    set_new_edit_render(@catalog_collection)
  end

  def create
    authorize @catalog_model
    @catalog_collection = @catalog_model.new(permitted_attributes(@catalog_model))    # Not the final implementation!
    if @catalog_collection.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def update
    authorize @catalog_collection
    if @catalog_collection.update_attributes(permitted_attributes(@catalog_collection))
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def destroy
    authorize @catalog_collection
    if @catalog_collection.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to action: :index
  end

  private

  def catalog_model_name(name)
    @catalog_model = name
  end

  def set_val
    @catalog_collection = @catalog_model.find(params[:id])
  end

  def set_index_render(search, main_collection)
    render partial: "catalog/catalog_list",
            locals: { q: search,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: main_collection,
                      new_path: url_for(action: 'new') }
  end

  def set_new_edit_render(catalog_name)
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: catalog_name,
           index_path: url_for(action: 'index') }
  end
end
