class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index 
    @comments = Comment.all
  end

  def new
    @comment = Comments.build
  end

  def create
    @event = Event.find(params[:comment][:event_id])
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to @event
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to event_path(@comment.event_id)
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body, :event_id, :user_id)
  end
end