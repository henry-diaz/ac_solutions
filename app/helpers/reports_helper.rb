# encoding: UTF-8
module ReportsHelper

  def draw_sales_report items
    rsl = ""
    if items.size > 0
      rsl << %(<div class="clearfix">#{link_to("Exportar a csv", export_sales_reports_url(:q => params[:q]), :class => "pull-right csv_link")}</div>)
      rsl << %(<table class="table table-striped table-condensed">)
        rsl << %(<thead>)
          rsl << %(<th>Fecha</th>)
          rsl << %(<th>Código<br>cliente</th>)
          rsl << %(<th>Nombre<br>cliente</th>)
          rsl << %(<th>Tipo</th>)
          rsl << %(<th>Código<br>item</th>)
          rsl << %(<th>Nombre<br>item</th>)
          rsl << %(<th>Cantidad</th>)
          rsl << %(<th>Precio<br>unitario</th>)
          rsl << %(<th>Total</th>)
        rsl << %(</thead>)
        rsl << %(<tbody>)
          items.each do |item|
            rsl << %(<tr>)
              rsl << %(<td>#{item.resourceable.sale_date.try(:strftime, "%d/%m/%Y") rescue ""}</td>)
              rsl << %(<td>#{item.resourceable.customer_code}</td>)
              rsl << %(<td>#{item.resourceable.customer_name}</td>)
              rsl << %(<td>#{item.itemable.is_a?(Sku) ? "Producto" : "Servicio"}</td>)
              rsl << %(<td>#{item.item_code}</td>)
              rsl << %(<td>#{item.item_name}</td>)
              rsl << %(<td class="center">#{item.quantity}</td>)
              rsl << %(<td class="right">#{number_to_currency(item.unit_price, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
              rsl << %(<td class="right">#{number_to_currency(item.subtotal, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
            rsl << %(</tr>)
          end
        rsl << %(</tbody>)
        rsl << %(<tfoot>)
          rsl << %(<tr><td colspan="9"></td></tr>)
          rsl << %(<tr>)
            rsl << %(<td colspan="6" class="right table-separator"><strong>TOTAL</strong></td>)
            rsl << %(<td class="center table-separator"><strong>#{items.map(&:quantity).inject(:+)}</strong></td>)
            rsl << %(<td class="table-separator">&nbsp;</td>)
            rsl << %(<td class="table-separator right"><strong>#{number_to_currency(items.map(&:subtotal).inject(:+), :negative_format => "<span class='negative'>(%u%n)</span>") rescue ""}</strong></td>)
          rsl << %(</tr>)
        rsl << %(</tfoot>)
      rsl << %(</table>)
    else
      rsl << %(<div class="well"><p class="select-task" style="margin: 0;">No hay resultados para mostrar</p></div>)
    end
    rsl.html_safe
  end

  def draw_purchases_report items
    rsl = ""
    if items.size > 0
      rsl << %(<div class="clearfix">#{link_to("Exportar a csv", export_purchases_reports_url(:q => params[:q]), :class => "pull-right csv_link")}</div>)
      rsl << %(<table class="table table-striped table-condensed">)
        rsl << %(<thead>)
          rsl << %(<th>Fecha</th>)
          rsl << %(<th>Tipo</th>)
          rsl << %(<th>Código<br>item</th>)
          rsl << %(<th>Nombre<br>item</th>)
          rsl << %(<th>Cantidad</th>)
          rsl << %(<th>Precio<br>unitario</th>)
          rsl << %(<th>Total</th>)
        rsl << %(</thead>)
        rsl << %(<tbody>)
          items.each do |item|
            rsl << %(<tr>)
              rsl << %(<td>#{item.resourceable.purchase_date.try(:strftime, "%d/%m/%Y") rescue ""}</td>)
              rsl << %(<td>#{item.item_kind == "product" ? "Producto" : "Material"}</td>)
              rsl << %(<td>#{item.item_code}</td>)
              rsl << %(<td>#{item.item_name}</td>)
              rsl << %(<td class="center">#{item.quantity}</td>)
              rsl << %(<td class="right">#{number_to_currency(item.unit_price, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
              rsl << %(<td class="right">#{number_to_currency(item.subtotal, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
            rsl << %(</tr>)
          end
        rsl << %(</tbody>)
        rsl << %(<tfoot>)
          rsl << %(<tr><td colspan="7"></td></tr>)
          rsl << %(<tr>)
            rsl << %(<td colspan="4" class="right table-separator"><strong>TOTAL</strong></td>)
            rsl << %(<td class="center table-separator"><strong>#{items.map(&:quantity).inject(:+)}</strong></td>)
            rsl << %(<td class="table-separator">&nbsp;</td>)
            rsl << %(<td class="table-separator right"><strong>#{number_to_currency(items.map(&:subtotal).inject(:+), :negative_format => "<span class='negative'>(%u%n)</span>") rescue ""}</strong></td>)
          rsl << %(</tr>)
        rsl << %(</tfoot>)
      rsl << %(</table>)
    else
      rsl << %(<div class="well"><p class="select-task" style="margin: 0;">No hay resultados para mostrar</p></div>)
    end
    rsl.html_safe
  end

  def draw_inventories_report items
    rsl = ""
    if items.size > 0
      rsl << %(<div class="clearfix">#{link_to("Exportar a csv", export_inventories_reports_url(:q => params[:q]), :class => "pull-right csv_link")}</div>)
      rsl << %(<table class="table table-striped table-condensed">)
        rsl << %(<thead>)
          rsl << %(<th>Estado</th>)
          rsl << %(<th>Tipo</th>)
          rsl << %(<th>Código</th>)
          rsl << %(<th>Nombre</th>)
          rsl << %(<th>Cantidad</th>)
        rsl << %(</thead>)
        rsl << %(<tbody>)
          items.each do |item|
            rsl << %(<tr>)
              rsl << %(<td>#{item.status}</td>)
              rsl << %(<td>#{item.get_kind}</td>)
              rsl << %(<td>#{item.code}</td>)
              rsl << %(<td>#{item.name}</td>)
              rsl << %(<td class="center">#{item.quantity}</td>)
            rsl << %(</tr>)
          end
        rsl << %(</tbody>)
        rsl << %(<tfoot>)
          rsl << %(<tr><td colspan="5"></td></tr>)
          rsl << %(<tr>)
            rsl << %(<td colspan="4" class="right table-separator"><strong>TOTAL</strong></td>)
            rsl << %(<td class="center table-separator"><strong>#{items.map(&:quantity).inject(:+)}</strong></td>)
          rsl << %(</tr>)
        rsl << %(</tfoot>)
      rsl << %(</table>)
    else
      rsl << %(<div class="well"><p class="select-task" style="margin: 0;">No hay resultados para mostrar</p></div>)
    end
    rsl.html_safe
  end

end
