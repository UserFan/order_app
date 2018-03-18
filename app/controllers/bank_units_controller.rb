class BankUnitsController < ApplicationController
  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize BankUnit
    @q =BankUnit.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @bank_units = @q.result(disinct: true)
  end

  def show
    authorize @bank_unit
  end

  def new
    authorize BankUnit
    @bank_unit = BankUnit.new
  end

  def edit
    authorize @bank_unit
  end

  def create
    authorize BankUnit
    @bank_unit = BankUnit.new(permitted_attributes(BankUnit))    # Not the final implementation!
    if @bank_unit.save
      redirect_to bank_units_path
    else
      render 'new'
    end
  end

  def update
    authorize @bank_unit
    if @bank_unit.update_attributes(permitted_attributes(@bank_unit))
     redirect_to bank_units_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @bank_unit
    if @bank_unit.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to bank_units_path
  end


  private

  def set_type
    @bank_unit = BankUnit.find(params[:id])
  end
end
