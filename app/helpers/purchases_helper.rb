module PurchasesHelper

  def draw_purchase_table purchase, item
    rsl = ""
      rsl << %(<table class="table table-striped table-condensed">)
        rsl << %(<thead>)
          rsl << %(<tr>)
            rsl << %(<th>#{t("labels.sku_code")}</th>)
            rsl << %(<th>#{t("labels.sku_name")}</th>)
            rsl << %(<th>#{t("labels.price")}</th>)
            rsl << %(<th>#{t("labels.quantity")}</th>)
            rsl << %(<th>#{t("labels.subtotal")}</th>)
            rsl << %(<th colspan=2>&nbsp;</th>)
          rsl << %(</tr>)
        rsl << %(</thead>)
        rsl << %(<tbody>)
        rsl << render(partial: "items/new", locals: { parent: purchase, item: item })
        purchase.items.each do |item|
          rsl << draw_purchase_row(purchase, item)
        end
        rsl << %(</tbody>)
        rsl << %(<tfoot><tr><td colspan=7></td></tr>)
        rsl << draw_purchase_footer_sum(purchase)
        rsl << %(</tfoot>)
      rsl << %(</table>)
      rsl << %(<div class="table-separator"></div>)
    rsl.html_safe
  end

  def draw_purchase_row purchase, item
    rsl = ""
    rsl << %(<tr class="row-grid" data-id="#{item.id}">)
      rsl << %(<td>#{item.item_code}</td>)
      rsl << %(<td>#{item.item_name}</td>)
      rsl << %(<td class="center">#{number_to_currency(item.unit_price, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
      rsl << %(<td class="center">#{item.quantity}</td>)
      rsl << %(<td class="center">#{number_to_currency(item.subtotal, :negative_format => "<span class='negative'>(%u%n)</span>")}</td>)
      rsl << %(<td>#{link_to(t("labels.edit"), polymorphic_path([purchase, item], :action => :edit), :class => "edit_link", :remote => true)}</td>)
      rsl << %(<td>#{link_to(t("labels.remove"), polymorphic_path([purchase, item]), :class => "remove_link", :method => :delete, :confirm => t("labels.confirm_delete_item"), :remote => true)}</td>)
    rsl << %(</tr>)
    rsl.html_safe
  end

  def draw_edit_purchase_row purchase, item
    rsl = ""
    rsl << %(<tr class="row-grid form-container" data-id="#{item.id}" data-edit=true>)
    rsl << %(<td>#{item.item_code}</td>)
    rsl << %(<td>#{item.item_name}</td>)
    rsl << %(<td class="center">#{text_field_tag("item[unit_price]", item.unit_price, :class => "input-mini")}</td>)
    rsl << %(<td class="center">#{text_field_tag("item[quantity]", item.quantity, :class => "input-mini")}</td>)
    rsl << %(<td class="center"></td>)
    rsl << %(<td colspan=2>#{link_to(t("labels.save"), "javascript:;", :class => "save_link submit-me", :'data-action' => polymorphic_path([purchase, item]), :'data-method' => :put)}</td>)
    rsl << %(</tr>)
    rsl.html_safe
  end

  def draw_purchase_footer_sum purchase
    rsl = ""
    rsl << %(<tr id="purchase-total">)
      rsl << %(<td class="table-separator right" colspan=4><strong>#{t("labels.total")}</strong></td>)
      rsl << %(<td class="table-separator center"><strong>#{number_to_currency(purchase.total, :negative_format => "<span class='negative'>(%u%n)</span>")}</strong></td>)
      rsl << %(<td class="table-separator" colspan=2>&nbsp;</td>)
    rsl << %(</tr>)
    rsl.html_safe
  end

end
