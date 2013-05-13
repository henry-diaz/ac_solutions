module SkusHelper

  def draw_skus skus
    rsl = ""
    rsl << %(<div class="clearfix">#{link_to(t("labels.add"), new_sku_url, :class => "add_link pull-right")}</div>)
    rsl << %(<table class="table table-striped table-condensed" style="margin-top: 3px;">)
      rsl << %(<thead>)
        rsl << %(<tr>)
          rsl << %(<th>#{sort_link(@q, :kind, t("labels.kind"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :active, t("labels.status"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :code, t("labels.code"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :name, t("labels.name"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :quantity, t("labels.quantity"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :unit_price, t("labels.sale_price"), { :controller => '/skus', :action => 'index' })}</th>)
          rsl << %(<th colspan=2>&nbsp;</th>)
        rsl << %(</tr>)
      rsl << %(</thead>)
      rsl << %(<tfoot><tr><td colspan=8></td></tr><tr><td class="table-separator" colspan=8>&nbsp;</td></tr></tfoot>)
      rsl << %(<tbody>)
        skus.each do |s|
          rsl << draw_sku(s)
        end
      rsl << %(</tbody>)
    rsl << %(</table>)
    rsl << %(<div class="center">)
      rsl << bootstrap_will_paginate(skus, :params => { :controller => "/skus", :action => "index" }) rescue ""
    rsl << %(</div>)
    raw(rsl)
  end

  def draw_sku sku
    rsl = ""
    rsl << %(<tr data-id="#{sku.id}">)
      rsl << %(<td>#{sku.get_kind}</td>)
      rsl << %(<td>#{sku.status}</td>)
      rsl << %(<td>#{sku.code}</td>)
      rsl << %(<td>#{sku.name}</td>)
      rsl << %(<td class="right">#{sku.quantity}</td>)
      rsl << %(<td class="right">#{sku.is_material? ? "--" : number_to_currency(sku.unit_price)}</td>)
      rsl << %(<td>#{link_to(t("labels.edit"), edit_sku_url(sku), :class => "edit_link")}</td>)
      rsl << %(<td>#{link_to(sku.active? ? t("labels.deactivate") : t("labels.activate"), toggle_sku_url(sku), :class => "#{sku.active? ? "deactivate_link" : "activate_link"}", :remote => true)}</td>)
    rsl << %(</tr>)
    raw(rsl)
  end

end
