class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  # Count number of total tickets and by status
  def index
    @tickets = Ticket.all.order(created_at: :desc)
    @total_tickets = @tickets.count
    @open_tickets = @tickets.where(status: [ "Open" ]).count
    @closed_tickets = @tickets.where(status: [ "Closed" ]).count
    @active_users = User.joins(:tickets).distinct.count

    # Group tickets by category
    @tickets_by_category = Ticket.group(:category).count
    @category_counts = Ticket.group(:category).count.presence || {}
  end

  private

  # Ensure the user is an admin
  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
