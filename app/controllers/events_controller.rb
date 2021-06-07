class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /events or /events.json
  def index
    @events = Event.all
    
    if user_signed_in?
      @invitations = Invitation.where(invitee_id: current_user.id)
    end
  end

  # GET /events/1 or /events/1.json
  def show
    @comment = Comment.new
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = current_user.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to root_path, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to root_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def enroll  
    @event = Event.find(params[:id])
    if !@event.attendees.include?(current_user)
      @event.attendees << current_user
    end
    inv = Invitation.where(event_id: @event.id).and(Invitation.where(invitee_id: current_user.id)).first
    if inv
      inv.destroy
    end
    redirect_to @event
  end

  def accept  
    @event = Event.find(params[:id])
    if !@event.attendees.include?(current_user)
      @event.attendees << current_user
    end
    inv = Invitation.where(event_id: @event.id).and(Invitation.where(invitee_id: current_user.id)).first
    inv.destroy
    redirect_to root_path
  end

  def decline  
    invitation = Invitation.find(params[:id])
    invitation.destroy
    redirect_to root_path
  end

  def cancel  
    @event = Event.find(params[:id])
    @event.attendees.delete(current_user)
    redirect_to @event
  end

  def invitation
    @event = Event.find(params[:id])
    @users = User.all
  end

  def invite
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    invitation = Invitation.new(event_id: @event.id, invitee_id: @user.id)
    if invitation.save
      flash[:notice] = "Invitation sent!"
      redirect_to invitation_event_path(@event)
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :date, :description)
    end
end
