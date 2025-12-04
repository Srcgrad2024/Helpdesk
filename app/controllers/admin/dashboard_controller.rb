class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @tickets = Ticket.all.order(created_at: :desc)
    @total_tickets = @tickets.count
    @open_tickets = @tickets.where(status: 'open').count
    @closed_tickets = @tickets.where(status: 'closed').count
    @active_users = User.joins(:tickets).distinct.count
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
end

