class OrderMailer < ApplicationMailer
  default from: 'Система контроля заявок АрышМае <service_order@arishmae.ru>'
  before_action :set_order_mailer

  def new_order
    @performer = params[:performer]
    mail(
      to: @user.email,
      subject: t('order_mailer.new_order.subject', number: @order.order_number))
  end

  def new_order_control
    mail(
      to: @user.email,
      subject: t('order_mailer.new_order_control.subject', number: @order.order_number))
  end

  def delete_order
    mail(
      to: @user.email,
      subject: t('order_mailer.delete_order.subject', number: @order.order_number))
  end

  def delete_order_control
    mail(
      to: @user.email,
      subject: t('order_mailer.delete_order_control.subject', number: @order.order_number))
  end

  def order_close
    mail(
      to: @user.email,
      subject: t('order_mailer.order_close.subject', number: @order.order_number))
  end

  def order_change
    mail(
      to: @user.email,
      subject: t('order_mailer.order_change.subject', number: @order.order_number))
  end

  def order_change_status
    case @order.status_id
      when Status::AGREE
        subject_text = t('order_mailer.order_change_status.subject_agree', number: @order.order_number)
        @content_status = t('order_mailer.order_change_status.content_agree', number: @order.order_number)
      when Status::COORDINATION
        subject_text = t('order_mailer.order_change_status.subject_coordination', number: @order.order_number)
        @content_status = t('order_mailer.order_change_status.content_coordination', number: @order.order_number)
      when Status::NOT_COORDINATION
        subject_text = t('order_mailer.order_change_status.subject_not_coordination', number: @order.order_number)
        @content_status = t('order_mailer.order_change_status.content_not_coordination', number: @order.order_number)
      else
        subject_text = t('order_mailer.order_change.subject', number: @order.order_number)
        @content_status = t('order_mailer.order_change.content_body', number: @order.order_number)
    end
    mail(to: @user.email, subject: subject_text)
  end

  # def order_agree
  #   mail(
  #     to: @user.email,
  #     subject: t('order_mailer.order_agree.subject', number: @order.order_number))
  # end
  #
  # def order_not_coordination
  #   mail(
  #     to: @user.email,
  #     subject: t('order_mailer.order_not_coordination.subject', number: @order.order_number))
  # end
  #
  # def order_coordination
  #   mail(
  #     to: @user.email,
  #     subject: t('order_mailer.order_coordination.subject', number: @order.order_number))
  # end

  def order_delete_execution
    mail(
      to: @user.email,
      subject: t('order_mailer.order_delete_execution.subject', number: @order.order_number))
  end

  def delete_performer_order
    mail(
      to: @user.email,
      subject: t('order_mailer.delete_performer_order.subject', number: @order.order_number))
  end

  private

  def set_order_mailer
    @user = params[:user]
    @order = params[:order]
  end


end
