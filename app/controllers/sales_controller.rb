class SalesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:create]
  respond_to :html

  def create
    sale.assign_attributes(customer_id: params[:customer_id], sale_date: Date.today)
    if sale.save
      redirect_to edit_sale_url(sale) and return
    else
      render :new
    end
  end

  def edit
    @item = Item.new(resourceable: sale)
  end

  def update
    respond_to do |format|
      @success = sale.update_attributes(params[:sale])
      if @success
        format.js
        format.json { render :json => {:success => true} }
      else
        format.js
        format.json { render :json => {:success => false, :message => @sale.errors.full_messages.join("<br>")} }
      end
    end
  end

  def destroy
    sale.destroy
    flash[:alert] = t("labels.sale_deleted_succesfully")
    respond_with(sale, location: sales_url)
  end

  def search_by_code
    @search = Sku.active.with_stock.where(code: params[:item_code]).first rescue nil
    render :json => { :success => true, :sku => @search.as_json( only: [:code, :name, :unit_price], methods: [:sku_id] ) }
  end

  def search_by_name
    @search = Sku.active.with_stock.where("name ilike ?", "%#{params[:item_name].gsub(' ', '%')}%").order("skus.code ASC")
    render :json => { :success => true, :skus => @search.as_json( :only => [:code, :name, :unit_price], :methods => [:sku_id] ) }
  end

  private
    def sales
      @sales ||= Sale.where(sale_date: Date.today)
    end
    helper_method :sales

    def sale
      @sale ||= params[:id] ? Sale.find(params[:id]) : Sale.new(params[:sale])
    end
    helper_method :sale
end
