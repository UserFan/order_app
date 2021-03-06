class OrderMailer < ApplicationMailer
  default from: 'Информационная система АрышМае <service_order@arishmae.ru>'
  before_action :set_order_mailer

  def order_send_mail_to_user
    @send_type = params[:send_type]
    subject_text = t("#{@locales_path}.subject_#{@send_type}", number: @order.order_number, status: @order.status.name)
    @content_text = t("#{@locales_path}.content_#{@send_type}",
                      number: @order.order_number,
                      date_start: l(@order.date_open, format: :date))
    mail(to: @user.email, subject: subject_text)
  end

  def order_send_mail_to_owner_user
    @send_type = params[:send_type]
    @performers = @order.performers

    subject_text = t("#{@locales_path}.subject_#{@send_type}", number: @order.order_number)
    @content_text = t("#{@locales_path}.content_#{@send_type}",
                      number: @order.order_number,
                      date_start: l(@order.date_open, format: :date))
    mail(to: @user.email, subject: subject_text)
  end

  def order_send_mail_to_user_coordination
    @send_type = params[:send_type]
    @execution = params[:execution]
    @execution_performer = @execution.performer.user.full_name

    subject_text = t("#{@locales_path}.subject_#{@send_type}", number: @order.order_number)
    @content_text = t("#{@locales_path}.content_#{@send_type}", number: @order.order_number)
    mail(to: @user.email, subject: subject_text)
  end


  private

  def set_order_mailer
    @locales_path = 'order_mailer.content_text'
    @user = params[:user]
    @order = params[:order]
  end


end
