class OrderMailer < ApplicationMailer
  default from: 'Система контроля заявок АрышМае <service_order@arishmae.ru>'
  before_action :set_order_mailer

  def new_order
    @performer = params[:performer]
    mail(
      to: @user.email,
      subject: t('order_mailer.new_order.subject', number: @order.order_number))
  end

  def order_control_user
    @send_type = params[:send_type]
    case @send_type
      when 'new_order'
        subject_text = t('order_mailer.order_control_user.subject_new_order', number: @order.order_number)
        @content_text = t('order_mailer.order_control_user.content_new_order', number: @order.order_number)
        @content_date = t('order_mailer.order_control_user.content_date', date_order: l(@order.date_execution, format: :date))
      when 'change_order'
        subject_text = t('order_mailer.content_text.subject_change_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_change_order', number: @order.order_number)
      when 'delete_order'
        subject_text = t('order_mailer.content_text.subject_delete_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_delete_order', number: @order.order_number)
      when 'delete_order_control'
        subject_text = t('order_mailer.content_text.subject_delete_order_control', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_delete_order_control', number: @order.order_number)
      when 'close_order'
        subject_text = t('order_mailer.content_text.subject_close_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_close_order', number: @order.order_number)
      when 'change_status'
        subject_text = t('order_mailer.content_text.subject_status_order', number: @order.order_number, status: (@order.status.name).downcase)
        @content_text = t('order_mailer.content_text.content_status_order', number: @order.order_number, status: (@order.status.name).downcase)
      else
        subject_text = t('order_mailer.content_text.subject_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_order', number: @order.order_number)
    end
    mail(to: @user.email, subject: subject_text)
  end

  def order_performer_user
    @send_type = params[:send_type]
    case @send_type
      when 'new_order'
        subject_text = t('order_mailer.order_performer_user.subject_new_order', number: @order.order_number)
        @content_text = t('order_mailer.order_performer_user.content_new_order', number: @order.order_number)
        @content_date = t('order_mailer.order_performer_user.content_date', date_order: l(@order.date_execution, format: :date))
      when 'change_order'
        subject_text = t('order_mailer.content_text.subject_change_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_change_order', number: @order.order_number)
      when 'delete_order'
        subject_text = t('order_mailer.content_text.subject_delete_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_delete_order', number: @order.order_number)
      when 'delete_order_control'
        subject_text = t('order_mailer.content_text.subject_delete_order_control', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_delete_order_control', number: @order.order_number)
      when 'close_order'
        subject_text = t('order_mailer.content_text.subject_close_order', number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_close_order', number: @order.order_number)
      when 'change_status'
        subject_text = t('order_mailer.content_text.subject_status_order', status: (@order.status.name).downcase, number: @order.order_number)
        @content_text = t('order_mailer.content_text.content_status_order', status: (@order.status.name).downcase, number: @order.order_number)
      else
        subject_text = t('order_mailer.order_control_user.subject_order', number: @order.order_number)
        @content_text = t('order_mailer.order_control_user.content_order', number: @order.order_number)
    end
      mail(to: @user.email, subject: subject_text)
  end

  # def new_order_control
  #   mail(
  #     to: @user.email,
  #     subject: t('order_mailer.new_order_control.subject', number: @order.order_number))
  # end

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

  def order_change
    @performers = @order.performers
    if @order.changed? || @order.performers_change?
      if @order.control_user_changed?
        send_control_user(@order.control_user_old, 'delete_order_control', @order)
        send_control_user(@user, 'new_order', @order)
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

  # def order_change_status(change_status = true)
  #   case @order.status_id
  #     when Status::AGREE
  #       subject_text = t('order_mailer.order_change_status.subject_agree', number: @order.order_number)
  #       @content_status = t('order_mailer.order_change_status.content_agree', number: @order.order_number)
  #     when Status::COORDINATION
  #       subject_text = t('order_mailer.order_change_status.subject_coordination', number: @order.order_number)
  #       @content_status = t('order_mailer.order_change_status.content_coordination', number: @order.order_number)
  #     when Status::NOT_COORDINATION
  #       subject_text = t('order_mailer.order_change_status.subject_not_coordination', number: @order.order_number)
  #       @content_status = t('order_mailer.order_change_status.content_not_coordination', number: @order.order_number)
  #     else
  #       change_status = false
  #   end
  #   if change_status
  #     OrderMailer.with(order: @order,
  #                      send_type: 'change_order').order_performer_user.deliver_now
  #     end
  #     mail(to: @user.email, subject: subject_text)
  #   end
  # end

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
    performers.find_each do |performer|
      OrderMailer.with(user: performer.user, order: order,
       send_type: send_type).order_performer_user.deliver_later unless performer.
       execution_off_control?
    end
  end

  def send_control_user(control_user, send_type, order)
    OrderMailer.with(user: control_user, order: order,
      send_type: send_type).order_control_user.deliver_later
  end

end
