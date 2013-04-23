class PurchasesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    redirect_to new_purchase_url and return if purchases.size == 0
  end

  def create
    if purchase.save
      redirect_to edit_purchase_url(purchase) and return
    else
      render :new
    end
  end

  def edit
    @item = Item.new(resourceable: purchase)
  end

  def update
    respond_to do |format|
      @success = purchase.update_attributes(params[:purchase])
      if @success
        format.js
        format.json { render :json => {:success => true} }
      else
        format.js
        format.json { render :json => {:success => false, :message => @purchase.errors.full_messages.join("<br>")} }
      end
    end
  end

  def destroy
    purchase.destroy
    flash[:alert] = t("labels.purchase_deleted_succesfully")
    respond_with(purchase, location: purchases_url)
  end

  def search_by_code
    @search = Sku.where(code: params[:item_code]).first rescue nil
    render :json => { :success => true, :sku => @search.as_json( only: [:code, :name], methods: [:sku_id] ) }
  end

  def search_by_name
    @search = Sku.where("name ilike ?", "%#{params[:item_name].gsub(' ', '%')}%").order("skus.code ASC")
    render :json => { :success => true, :skus => @search.as_json( :only => [:code, :name], :methods => [:sku_id] ) }
  end

  private
    def purchases
      @purchases ||= Purchase.where(purchase_date: Date.today)
    end
    helper_method :purchases

    def purchase
      @purchase ||= params[:id] ? Purchase.find(params[:id]) : Purchase.new(params[:purchase])
    end
    helper_method :purchase
end