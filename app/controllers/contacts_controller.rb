class ContactsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def create
    @success = contact.save
  end

  def update
    @success = contact.update_attributes(params[:contact])
  end

  private
    def customer
      @customer ||= params[:customer_id] ? Customer.find(params[:customer_id]) : Customer.new
    end
    helper_method :customer

    def contact
      @contact ||= params[:id] ? customer.contacts.find(params[:id]) : customer.contacts.new(params[:contact])
    end
    helper_method :contact
end
