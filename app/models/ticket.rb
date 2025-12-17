# Model to manage the tickets tables in the application, when a user creates or updates a ticket
class Ticket < ApplicationRecord
  # Ticket belongs to a user and has many comments after which it broadcasts updates for the category chart
  belongs_to :user
  has_many :comments, dependent: :destroy
  after_commit :broadcast_category_chart_update
  
  # Custom error messages for validations, to show at the top of the tickets form
  validate :custom_messages

  # Fields cannot be blank, when user creates or updates a ticket
  def custom_messages
    errors.add(:base, "Summary cannot be blank") if title.blank?
    errors.add(:base, "Please select Category") if category.blank?
    errors.add(:base, "Please select Sub category") if sub_category.blank?
  end

  before_create :set_default_status

  private

  # Set default status to "New" when a ticket is created
  def set_default_status
    self.status ||= "New"
  end

  # Broadcast Updates for the graph when tickets are created or updated
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
