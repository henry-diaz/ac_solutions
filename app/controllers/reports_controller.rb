class ReportsController < ApplicationController
  before_filter :authenticate_user!
  # limpiamos y preparamos params
  before_filter :clean_params, :only => [:sales, :purchases, :inventories]
  before_filter :convert_params_to_array, :only => [:sales, :purchases, :inventories]
  # filtros para reportes
  before_filter :prepare_sales_report, :only => [:sales, :export_sales]
  before_filter :prepare_purchases_report, :only => [:purchases, :export_purchases]
  before_filter :prepare_inventories_report, :only => [:inventories, :export_inventories]

  respond_to :html, :js

  PER_PAGE = 30
  require 'csv'

  def export_sales
    csv_string = CSV.generate do |csv|
      begin
        csv << ["Reporte de ventas #{Date.today.try(:strftime, "%d/%m/%Y")}"]
        csv << ["Fecha", "Codigo cliente", "Nombre cliente", "Tipo", "Codigo item", "Nombre item", "Cantidad", "Precio unitario", "Total"]
        @items.each do |item|
          csv << [(item.resourceable.sale_date.try(:strftime, "%d/%m/%Y") rescue ""), item.resourceable.customer_code, item.resourceable.customer_name, (item.itemable.is_a?(Sku) ? "Producto" : "Servicio"), item.item_code, item.item_name, item.quantity, item.unit_price, item.subtotal]
        end
        csv << ["","","","","","TOTAL",@items.map(&:quantity).inject(:+),"",@items.map(&:subtotal).inject(:+)]
      rescue
        csv << ["Hubo un error al generar el reporte"]
      end
    end
    send_data csv_string, :type => "application/excel", :filename=>"sales_report_#{Time.now.to_i}.csv", :disposition => 'attachment'
  end

  def export_purchases
    csv_string = CSV.generate do |csv|
      begin
        csv << ["Reporte de compras #{Date.today.try(:strftime, "%d/%m/%Y")}"]
        csv << ["Fecha", "Tipo", "Codigo item", "Nombre item", "Cantidad", "Precio unitario", "Total"]
        @items.each do |item|
          csv << [(item.resourceable.purchase_date.try(:strftime, "%d/%m/%Y") rescue ""), (item.item_kind == 'product' ? "Producto" : "Material"), item.item_code, item.item_name, item.quantity, item.unit_price, item.subtotal]
        end
        csv << ["","","","TOTAL",@items.map(&:quantity).inject(:+),"",@items.map(&:subtotal).inject(:+)]
      rescue
        csv << ["Hubo un error al generar el reporte"]
      end
    end
    send_data csv_string, :type => "application/excel", :filename=>"purchases_report_#{Time.now.to_i}.csv", :disposition => 'attachment'
  end

  def export_inventories
    csv_string = CSV.generate do |csv|
      begin
        csv << ["Reporte de inventarios #{Date.today.try(:strftime, "%d/%m/%Y")}"]
        csv << ["Estado", "Tipo", "Codigo", "Nombre", "Cantidad"]
        @items.each do |item|
          csv << [item.status, item.get_kind, item.code, item.name, item.quantity]
        end
        csv << ["","","","TOTAL",@items.map(&:quantity).inject(:+)]
      rescue
        csv << ["Hubo un error al generar el reporte"]
      end
    end
    send_data csv_string, :type => "application/excel", :filename=>"purchases_report_#{Time.now.to_i}.csv", :disposition => 'attachment'
  end

  def tokenize_customers
    customers = Customer.search(:info_cont => params[:q]).result().limit(30)
    json_customers = []
    customers.each do |c|
      json_customers << { id: c.id, name: c.info }
    end
    render :json => json_customers
  end

  def tokenize_skus
    skus = Sku.search(:info_cont => params[:q]).result().limit(30)
    json_skus = []
    skus.each do |s|
      json_skus << { id: s.id, name: s.info }
    end
    render :json => json_skus
  end

  def tokenize_services
    services = Service.search(:info_cont => params[:q]).result().limit(30)
    json_services = []
    services.each do |s|
      json_services << { id: s.id, name: s.info }
    end
    render :json => json_services
  end

  private
    def prepare_sales_report
      @options = {
                  :sale_date_gteq => Date.today.beginning_of_week,
                  :sale_date_lteq => Date.today,
                  :klass_in => ['Sku', 'Service'],
                  :kind_in => ['bill', 'fiscal']
                }
      @options.merge!(params[:q].symbolize_keys) if params[:q]
      @options[:sale_date_gteq] = Date.parse(@options[:sale_date_gteq]) unless @options[:sale_date_gteq].is_a?(Date)
      @options[:sale_date_lteq] = Date.parse(@options[:sale_date_lteq]) unless @options[:sale_date_lteq].is_a?(Date)
      @items                    = Item.by_type(Sale).sales_by_filters(@options).reorder("items.created_at ASC")
    end
    def prepare_purchases_report
      @options = {
                  :purchase_date_gteq => Date.today.beginning_of_week,
                  :purchase_date_lteq => Date.today,
                  :kind_in => ['bill', 'fiscal']
                }
      @options.merge!(params[:q].symbolize_keys) if params[:q]
      @options[:purchase_date_gteq] = Date.parse(@options[:purchase_date_gteq]) unless @options[:purchase_date_gteq].is_a?(Date)
      @options[:purchase_date_lteq] = Date.parse(@options[:purchase_date_lteq]) unless @options[:purchase_date_lteq].is_a?(Date)
      @items                        = Item.by_type(Purchase).purchases_by_filters(@options).reorder("items.created_at ASC")
    end
    def prepare_inventories_report
      @options = {
                  :kind_in => ['product', 'material']
                }
      @options.merge!(params[:q].symbolize_keys) if params[:q]
      @items = Sku.by_filters(@options).reorder("skus.created_at ASC")
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
        params[:q][:customer_id_in]   = params[:q][:customer_id_in].split(",")  if params[:q][:customer_id_in].present?
        params[:q][:sku_id_in]        = params[:q][:sku_id_in].split(",")       if params[:q][:sku_id_in].present?
        params[:q][:service_id_in]    = params[:q][:service_id_in].split(",")   if params[:q][:service_id_in].present?
        params[:q][:id_in]            = params[:q][:id_in].split(",")           if params[:q][:id_in].present?
      end
    end
end
