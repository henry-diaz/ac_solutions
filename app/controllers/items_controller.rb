class ItemsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js

  def create
    itemables = parent.items.map(&:itemable)
    @item = parent.items.new(params[:item])
    if itemables.include?(@item.itemable)
      flash[:alert] = t("labels.item_already_exist")
    else
      @success = @item.save
    end
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
