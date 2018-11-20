class Profile < ApplicationRecord
  mount_uploader :avatar, ImageUploader

  belongs_to :user

  validates :surname, :first_name, :mobile, :date_recruitment, presence: true

  before_save :name_capitalize

  def full_name
    "#{surname} #{first_name} #{middle_name}"
  end

  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new('CONCAT_WS', [
      Arel::Nodes.build_quoted(' '), parent.table[:surname], parent.table[:first_name],
      parent.table[:middle_name]])
  end

  private

    def name_capitalize
      self.surname = surname.downcase.capitalize if surname.present?
      self.first_name = first_name.downcase.capitalize if first_name.present?
      self.middle_name = middle_name.downcase.capitalize if middle_name.present?
      #binding.pry
    end

end
