class OrderMailer < ApplicationMailer
  default from: 'service_order@arishmae.ru'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Ок. Test')
  end

  def delete_performer_order
    @user = params[:user]
    @order = params[:order]
    mail(to: @user.email, subject: "#{@user.full_name} your delete Order №#{@order.order_number}")
  end
end
