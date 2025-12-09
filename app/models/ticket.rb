class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "New"
  end
end
