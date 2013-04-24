class CustomersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @q = Customer.search(params[:q])
    @customers = @q.result().page(params[:page]).per_page(PER_PAGE)
  end

  def create
    if customer.save
      flash[:notice] = t("labels.customer_added_succesfully")
      redirect_to edit_customer_url(customer) and return
    else
      render :new
    end
  end

  def update
    flash[:notice] = t("labels.customer_updated_succesfully") if customer.update_attributes(params[:customer])
    respond_with(customer, location: customers_url)
  end

  def destroy
    customer.destroy
    flash[:alert] = t("labels.customer_deleted_succesfully")
    respond_with(customer, location: customers_url)
  end

  def find_customers
    customers = Customer.active.limit(30).search(:info_cont => params[:term].gsub(' ','%')).result()
    json = Array.new
    customers.each do |c|
      json << { :label => c.info, :value => c.info, :id => c.id }
    end
    render :json => json
  end

  private
    def customer
      @customer ||= params[:id] ? Customer.find(params[:id]) : Customer.new(params[:customer])
    end
    helper_method :customer
end
