class ItemsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js

  def create
    sku_ids = parent.items.map(&:sku_id)
    @item = parent.items.new(params[:item])
    if sku_ids.include?(@item.sku_id)
      flash[:alert] = t("labels.item_already_exist")
    else
      @success = @item.save
    end
    #if @parent.is_a?(Sale) and !@parent.warehouse.stocks.map(&:sku_code).flatten.include? @item.sku_code and @item.sku.has_implicit?
      #flash[:alert] = t("labels.item_not_in_stock")
    #else
      #skus_by_parent = @parent.items.unscoped.map(&:sku_code)
      #if skus_by_parent.include?(params[:item][:sku_code])
        #flash[:alert] = t("labels.item_already_exist")
      #else
        #@success = @item.save
      #end
      #skus_by_parent = nil
    #end
  end

  def destroy
    item.destroy
  end

  def update
    @success = item.update_attributes(params[:item])
  end

  private
    def parent
      @parent ||= params[:purchase_id] ? Purchase.find(params[:purchase_id]) : ( params[:sale_id] ? Sale.find(params[:sale_id]) : nil )
    end
    helper_method :parent

    def item
      @item ||= params[:id] ? Item.find(params[:id]) : Item.new(params[:item])
    end
    helper_method :item
end
