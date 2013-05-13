class ServicesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @q = Service.search(params[:q])
    @services = @q.result().page(params[:page]).per_page(PER_PAGE)
  end

  def create
    if service.save
      flash[:notice] = t("labels.service_added_succesfully")
      redirect_to services_url and return
    else
      render :new
    end
  end

  def update
    flash[:notice] = t("labels.service_updated_succesfully") if service.update_attributes(params[:service])
    respond_with(service, location: services_url)
  end

  def toggle
    @success = service.update_column(:active, service.active? ? Service::INACTIVE : Service::ACTIVE)
  end

  private
    def service
      @service ||= params[:id] ? Service.find(params[:id]) : Service.new(params[:service])
    end
    helper_method :service
end
