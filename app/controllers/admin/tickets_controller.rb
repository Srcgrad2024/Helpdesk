class Admin::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @tickets = Ticket.includes(:user).order(created_at: :desc)
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to admin_tickets_path, notice: "Ticket status updated."
    else
      redirect_to admin_tickets_path, alert: "Failed to update status."
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to admin_tickets_path, notice: "Ticket deleted."
  end


  #sort functionality
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

  private

  def ticket_params
    params.require(:ticket).permit(:status, :destroy)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end

