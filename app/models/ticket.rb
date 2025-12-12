class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  #field validations cannot be blank
  validate :custom_messages

  def custom_messages
    errors.add(:base, "Summary cannot be blank") if title.blank?
    errors.add(:base, "Please select Category") if category.blank?
    errors.add(:base, "Please select Sub category") if sub_category.blank?
  end


  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "New"
  end
end
