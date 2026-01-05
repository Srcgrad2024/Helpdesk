# Controller for managing tickets in the admin panel
class Admin::TicketsController < ApplicationController
  # Ensure user is authenticated and is an admin
  before_action :authenticate_user!
  before_action :authorize_admin!

  # Update ticket status
  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to admin_tickets_path, notice: "Ticket status updated."
    else
      redirect_to admin_tickets_path, alert: "Failed to update status."
    end
  end

  # Delete a ticket
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to admin_tickets_path, notice: "Ticket deleted."
  end

  # Search/filter functionality for tickets. By title/summary, description, category, sub‑category or status
  def index
    @tickets = Ticket.includes(:user)

    if params[:search].present?
      q = "%#{params[:search].downcase}%"
      @tickets = @tickets.where(
        "LOWER(title) LIKE :q OR LOWER(description) LIKE :q OR LOWER(category) LIKE :q OR LOWER(sub_category) LIKE :q OR LOWER(status) LIKE :q",
        q: q
      )
    end

  # Sorting tickets based on parameters
    case params[:sort]
    when "status"
      @tickets = @tickets.order(:status)
    when "created_at"
      @tickets = @tickets.order(created_at: :desc)
    else
      @tickets = @tickets.order(created_at: :desc)
    end
  end

  # Private methods for strong parameters and authorization
  private
 
  # Permitted parameters for ticket update
  def ticket_params
    params.require(:ticket).permit(:status, :destroy)
  end

  # Authorization check for admin users
  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
