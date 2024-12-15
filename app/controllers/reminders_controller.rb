class RemindersController < ApplicationController
  #load_and_authorize_resource
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  def index
    Rails.logger.info 'this here to get the request'
    logger.info "Processing the request..."
    @reminders = Reminder.all 
  end

  def show
    respond_with @reminder
  end

  def new
    @reminder = Reminder.new
  end

  def edit
  end

  def create
    Time.zone = reminder_params[:time_zone]
    @reminder = current_user.reminders.new(reminder_params)
    respond_with @reminder if @reminder.save!
  end

  def update
    Time.zone = reminder_params[:time_zone]
    flash[:notice] = 'Reminder was successfully updated.' if update_att_and_job
    respond_with @reminder
  end


  def destroy
    respond_with @reminder.destroy
  end

  private

    def update_att_and_job
      @reminder.update_attributes(reminder_params) && @reminder.update_sidekiq_job
    end

    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    def reminder_params
      params.require(:reminder).permit(:title, :description, :time, :time_zone)
    end
end
