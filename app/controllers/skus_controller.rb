class SkusController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @q = Sku.search(params[:q])
    @skus = @q.result().page(params[:page]).per_page(PER_PAGE)
  end

  def create
    if sku.save
      flash[:notice] = t("labels.sku_added_succesfully")
      redirect_to skus_url and return
    else
      render :new
    end
  end

  def update
    flash[:notice] = t("labels.sku_updated_succesfully") if sku.update_attributes(params[:sku])
    respond_with(sku, location: skus_url)
  end

  def toggle
    @success = sku.update_column(:active, sku.active? ? Sku::INACTIVE : Sku::ACTIVE)
  end

  private
    def sku
      @sku ||= params[:id] ? Sku.find(params[:id]) : Sku.new(params[:sku])
    end
    helper_method :sku
end
