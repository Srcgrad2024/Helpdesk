# Controller for managing tickets in the admin panel
class Admin::TicketsController < ApplicationController
  # Ensure user is authenticated and is an admin
  before_action :authenticate_user!
  before_action :authorize_admin!

  # List all tickets with sorting functionality
  def index
    @tickets = Ticket.includes(:user).order(created_at: :desc)
  end

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

  # Sorting tickets based on parameters
  def index
    sort = params[:sort]

    @tickets = case sort
    when "status"
                 Ticket.order(:status)
    when "created_at"
                 Ticket.order(created_at: :desc)
    else
                 Ticket.all
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
