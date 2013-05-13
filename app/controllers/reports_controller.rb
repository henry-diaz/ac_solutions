class ReportsController < ApplicationController
  before_filter :authenticate_user!
  # limpiamos y preparamos params
  before_filter :clean_params, :only => [:sales, :transactions, :inventories, :optimal, :credits]
  before_filter :convert_params_to_array, :only => [:sales, :transactions, :inventories, :optimal, :credits]
  # filtros para reportes
  before_filter :prepare_sales_report, :only => [:sales, :export_sales]
  before_filter :prepare_purchases_report, :only => [:purchases, :export_purchases]
  before_filter :prepare_inventories_report, :only => [:inventories, :export_inventories]

  respond_to :html, :js

  PER_PAGE = 30

  private
    def prepare_sales_report
    end
    def prepare_purchases_report
    end
    def prepare_inventories_report
    end
    def clean_params
      if params[:q]
        # limpiamos los filtros de busqueda si vienen en blanco
        params[:q].symbolize_keys
        params[:q].each{ |key, val| params[:q].delete(key) if val.blank? }
        params.delete("q") if params[:q].blank?
      end
    end
    def convert_params_to_array
      if params[:q]
        params[:q][:customer_code_in]  = params[:q][:customer_code_in].split(",")  if params[:q][:customer_code_in].present?
        params[:q][:sku_code_in]       = params[:q][:sku_code_in].split(",")       if params[:q][:sku_code_in].present?
        params[:q][:items_sku_code_in] = params[:q][:items_sku_code_in].split(",") if params[:q][:items_sku_code_in].present?
      end
    end
end
