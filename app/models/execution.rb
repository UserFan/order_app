class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :performer

  has_many :reworks, dependent: :destroy


  validates :performer_id, :comment, :order_execution, presence: true



  def execution_result
    Status.find(order_execution).name if order_execution.present?
  end



end
