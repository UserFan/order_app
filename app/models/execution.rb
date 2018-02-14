class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader
  
  belongs_to :performer

  validates :performer_id, :comment, :order_execution, presence: true


end
