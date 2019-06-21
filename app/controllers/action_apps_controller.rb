class ActionAppsController < ApplicationController
  before_action :set_action_app, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize ActionApp
    @q = ActionApp.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @action_apps = @q.result(disinct: true)
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @action_apps,
                      new_path: url_for(action: 'new') }
  end

  def show
    authorize @action_name
  end

  def new
    authorize ActionApp
    @action_app = ActionApp.new
  end

  def edit
    authorize @action_app
  end

  def create
    authorize ActionApp
    @action_app = ActionApp.new(permitted_attributes(ActionApp))    # Not the final implementation!
    if @action_app.save
      redirect_to action_apps_path
    else
      render 'new'
    end
  end

  def update
    authorize @action_app
    if @action_app.update_attributes(permitted_attributes(@action_app))
      redirect_to action_apps_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @action_app
    if @action_app.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to action_apps_path
  end


  private

  def set_action_app
    @action_app = ActionApp.find(params[:id])
  end
end
