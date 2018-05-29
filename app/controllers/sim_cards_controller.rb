class SimCardsController < ApplicationController
  before_action :set_sim_card, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize SimCard
    @q =SimCard.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @sim_cards = @q.result(disinct: true)
  end

  def show
    authorize @sim_card
  end

  def new
    authorize SimCard
    @sim_card = SimCard.new
  end

  def edit
    authorize @sim_card
  end

  def create
    authorize SimCard
    @sim_card = SimCard.new(permitted_attributes(SimCard))    # Not the final implementation!
    if @sim_card.save
      redirect_to sim_cards_path
    else
      render 'new'
    end
  end

  def update
    authorize @sim_card
    if @sim_card.update_attributes(permitted_attributes(@sim_card))
      redirect_to sim_cards_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @sim_card
    if @sim_card.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to sim_cards_path
  end


  private

  def set_sim_card
    @sim_card = SimCard.find(params[:id])
  end
end