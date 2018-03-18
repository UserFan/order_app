class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :performer

  validates :performer_id, :comment, :order_execution, presence: true


  def execution_result
    Status.find(order_execution).name
  end

end
