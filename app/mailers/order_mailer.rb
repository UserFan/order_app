class OrderMailer < ApplicationMailer
  default from: 'Система контроля заявок АрышМае <service_order@arishmae.ru>'
  before_action :set_order_mailer

  def new_order
    @performer = params[:performer]
    mail(
      to: @user.email,
      subject: t('order_mailer.new_order.subject', number: @order.order_number))
  end

  def order_send_mail_to_user
    locales_path = 'order_mailer.content_text'
    @performer = params[:performer]
    @send_type = params[:send_type]
    subject_text = t("#{locales_path}.subject_#{@send_type}", number: @order.order_number)
    @content_text = t("#{locales_path}.content_#{@send_type}", number: @order.order_number)
    @content_date = t("#{locales_path}.content_date_#{@send_type}",
                      date_order: l(@order.date_execution, format: :date))
    mail(to: @user.email, subject: subject_text)
  end

  def delete_order
    mail(
      to: @user.email,
      subject: t('order_mailer.delete_order.subject', number: @order.order_number))
  end

  # def delete_order_control
  #   mail(
  #     to: @user.email,
  #     subject: t('order_mailer.delete_order_control.subject', number: @order.order_number))
  # end

  def order_close
    mail(
      to: @user.email,
      subject: t('order_mailer.order_close.subject', number: @order.order_number))
  end

  def send_mail_order_change
    @performers = @order.performers
    #binding.pry
    if @order.changed? #|| @order.performers_change?
      if @order.control_user_changed?
        send_control_user(@order.control_user_old, 'delete_order_control', @order)
        send_control_user(@user, 'new_order_control', @order)
      end
      #unless @order.performers_change? || order_status_change?(@order.status_id)
      send_control_user(@user, 'change_order', @order)
      send_mail_performers(@performers, 'change_order', @order)
      #else
      if order_status_change?(@order.status_id)
        send_mail_performers(@performers, 'change_status', @order)
        send_control_user(@user, 'change_status', @order)
      end
      #binding.pry
    end
  end


  def order_execution
    @flag = params[:flag]
    @execution = params[:execution]
    @executor = @order.performers.find_by(coexecutor: false).user
    @performer = @execution.performer
    @order_control_user = User.find(@order.user_id)
    binding.pry
    # OrderMailer.with(user: @order_control_user, order: @order,
    #                  send_type: 'change_order').order_control_user.deliver_now
    # if @execution.completed.present?
    #
    #   unless @performer.coexecutor
    #     # OrderMailer.with(user: @performer.user, order: @order,
    #     #                  send_type: 'change_order').order_performer_user.deliver_now
    #     OrderMailer.with(user: @executor, order: @order,
    #                      send_type: 'delete_order_control').order_performer_user.deliver_now
    #   else
    #     OrderMailer.with(user: @performer.user, order: @order,
    #                      send_type: 'delete_order_control').order_performer_user.deliver_now
    #     OrderMailer.with(user: @executor, order: @order,
    #                      send_type: 'change_order').order_performer_user.deliver_now
    #   end
    # elsif @flag
    #   OrderMailer.with(user: @order_control_user, order: @order,
    #                    send_type: 'change_order').order_control_user.deliver_now
    #   send_mail_performer(@order.performers, 'change_order', @order)
    # end
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

  def order_status_change?(status)
    [Status::AGREE, Status::COORDINATION, Status::NOT_COORDINATION].
    include?(status) ? true : (return false)
  end

  def send_mail_performers(performers, send_type, order)
    performers.each do |performer|
      OrderMailer.with(user: performer.user, order: order,
       send_type: send_type, performer: performer).order_send_mail_to_user.deliver_later unless performer.
       execution_off_control?
    end
  end

  def send_control_user(control_user, send_type, order)
    OrderMailer.with(user: control_user, order: order,
      send_type: send_type).order_send_mail_to_user.deliver_now
  end

end
