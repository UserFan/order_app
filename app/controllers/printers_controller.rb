class PrintersController < ApplicationController
  before_action :set_printer, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Printer
    @q =Printer.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @printers = @q.result(disinct: true)
    set_index_render(@q, @printers, new_printer_path)
  end

  def show
    authorize @printer
  end

  def new
    authorize Printer
    @printer = Printer.new
    set_new_edit_render(@printer, printers_path)
  end

  def edit
    authorize @printer
    set_new_edit_render(@printer, printers_path)
  end

  def create
    authorize Printer
    @printer = Printer.new(permitted_attributes(Printer))    # Not the final implementation!
    if @printer.save
      redirect_to printers_path
    else
      render 'new'
    end
  end

  def update
    authorize @printer
    if @printer.update_attributes(permitted_attributes(@printer))
     redirect_to printers_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @printer
    if @printer.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to printers_path
  end


  private

  def set_printer
    @printer = Printer.find(params[:id])
  end
end
