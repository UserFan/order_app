class EmployeesController < ApplicationController
  before_action :set_employee, only: [:update, :destroy, :edit]
  before_action :set_user
  after_action :verify_authorized

  def new
    authorize Employee
    @employee = @user.employees.build
  end

  def edit
    authorize @employee
  end

  def create
    authorize Employee
    @employee = @user.employees.create(permitted_attributes(Employee))
    if @employee.save
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def update
    authorize @employee
    if @employee.update_attributes(permitted_attributes(@employee))
     redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @employee
    if @employee.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end



end
