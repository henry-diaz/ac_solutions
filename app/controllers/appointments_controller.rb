class AppointmentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :redirect_to_show, only: [:edit]
  respond_to :html

  def index
    @date = params[:month] ? Date.parse(params[:month]) : Date.today rescue Date.today
    @appointments = Appointment.by_user(current_user).by_date(@date)
  end

  def create
    appointment.user_id = current_user.id
    if appointment.save
      redirect_to appointments_url
    else
      render :new
    end
  end

  def update
    if appointment.update_attributes(params[:appointment])
      redirect_to appointments_url
    else
      render :edit
    end
  end

  def destroy
    appointment.destroy
    redirect_to appointments_url
  end

  private
    def appointment
      @appointment ||= params[:id] ? Appointment.find(params[:id]) : Appointment.new(params[:appointment])
    end
    helper_method :appointment

    def redirect_to_show
      redirect_to appointment_url(appointment) and return unless current_user.role?(:admin) or appointment.user_id == current_user.id
    end
end
