class Admin::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to admin_tickets_path, notice: "Comment added."
    else
      redirect_to admin_tickets_path, alert: "Failed to add comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
