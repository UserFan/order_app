class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :performer

  has_many :reworks, dependent: :destroy

  # around_destroy :destroy_execution_mail
  # after_create :send_execution_user
  # around_save :send_execution_user

  validates :performer_id, :comment, :order_execution, presence: true



  def execution_result
    Status.find(order_execution).name if order_execution.present?
  end


  def send_execution_user
    # OrderMailer.with(order: self.performer.order, execution: self).order_execution.deliver_now
    #yield
  end

  # def destroy_execution_mail
  #   OrderMailer.with(order: self.performer.order, execution: self, flag: true).order_execution.deliver_now
  # end

end
