class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy]
  before_action :authorize_ticket!, only: %i[show edit update destroy]

  def index
    @tickets = current_user.tickets.order(created_at: :desc)
  end

  def new
    @ticket = current_user.tickets.build
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if @ticket.save
      redirect_to @ticket, notice: 'Ticket created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path, notice: 'Ticket deleted.'
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def authorize_ticket!
    redirect_to tickets_path, alert: 'Not authorized.' unless @ticket.user_id == current_user.id
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :status)
  end
end
