class OrderMailer < ApplicationMailer
  default from: 'Система контроля заявок АрышМае <service_order@arishmae.ru>'
  before_action :set_order_mailer

  def order_send_mail_to_user
    locales_path = 'order_mailer.content_text'
    @performer = params[:performer]
    @send_type = params[:send_type]
    @send_type == 'new_order_performer' ? date_execution = @performer.date_performance : date_execution = @order.date_execution
    subject_text = t("#{locales_path}.subject_#{@send_type}", number: @order.order_number, status: @order.status.name)
    @content_text = t("#{locales_path}.content_#{@send_type}", number: @order.order_number, status: @order.status.name)
    @content_date = t("#{locales_path}.content_date_#{@send_type}",
                      date_order: l(date_execution, format: :date))
    mail(to: @user.email, subject: subject_text)
  end

  def send_mail_to_user_order_change
    obejct_model = params[:name_model]
    user_type = params[:user_type]
    if obejct_model.user_id_changed?
      user_old = User.find(obejct_model.user_id_was)
      send_user(user_old, "delete_order_#{user_type}", @order)
      unless user_type == 'performer'
        send_user(@user, "new_order_#{user_type}", @order)
      else
        OrderMailer.with(user: @user, order: @order,
          send_type: "new_order_#{user_type}", performer: obejct_model).
         order_send_mail_to_user.deliver_later(wait: 20.seconds) unless @order.date_closed.present?
      end
    elsif (order_status_change?(@order.status_id) || (user_type == 'execution_delete'))
      (user_type == 'execution_delete') ? text_type = "change_order" : text_type = "status_order"
      send_user(@user, text_type, @order) unless (user_type == 'execution_delete')
      @order.performers.find_each { |performer| send_user(performer.user,
        text_type, @order) unless performer.execution_off_control? }
    else
      send_user(@user, "change_order", @order)
    end
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

  def send_user(user, send_type, order)
    # #binding.pry
    OrderMailer.with(user: user, order: order,
      send_type: send_type).order_send_mail_to_user.deliver_later(wait: 10.seconds) unless order.date_closed.present?
  end


end
