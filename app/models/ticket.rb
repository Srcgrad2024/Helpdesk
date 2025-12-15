class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  after_commit :broadcast_category_chart_update

  # field validations cannot be blank
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

  # Broadcast Updates When Tickets Change
  def broadcast_category_chart_update
    Turbo::StreamsChannel.broadcast_replace_to(
      "dashboard",
      target: "category_chart",
      partial: "admin/dashboard/category_chart",
      locals: {
        category_counts: Ticket.group(:category).count
      }
    )
  end
end
