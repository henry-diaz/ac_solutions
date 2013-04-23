module CustomersHelper

  def draw_customers customers
    rsl = ""
    rsl << %(<div class="clearfix">#{link_to(t("labels.add"), new_customer_url, :class => "add_link pull-right")}</div>)
    rsl << %(<table class="table table-striped table-condensed" style="margin-top: 3px;">)
      rsl << %(<thead>)
        rsl << %(<tr>)
          rsl << %(<th>#{sort_link(@q, :active, t("labels.status"), { :controller => '/customers', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :kind, t("labels.kind"), { :controller => '/customers', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :name, t("labels.name"), { :controller => '/customers', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :phone, t("labels.phone"), { :controller => '/customers', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :address, t("labels.address"), { :controller => '/customers', :action => 'index' })}</th>)
          rsl << %(<th colspan=2>&nbsp;</th>)
        rsl << %(</tr>)
      rsl << %(</thead>)
      rsl << %(<tfoot><tr><td colspan=7></td></tr><tr><td class="table-separator" colspan=7>&nbsp;</td></tr></tfoot>)
      rsl << %(<tbody>)
        customers.each do |c|
          rsl << %(<tr>)
            rsl << %(<td>#{c.status}</td>)
            rsl << %(<td>#{c.get_kind}</td>)
            rsl << %(<td>#{c.name}</td>)
            rsl << %(<td>#{c.phone}</td>)
            rsl << %(<td>#{c.address}</td>)
            rsl << %(<td>#{link_to(t("labels.edit"), edit_customer_url(c), :class => "edit_link")}</td>)
            rsl << %(<td>#{link_to(t("labels.delete"), customer_url(c), :class => "remove_link", :method => :delete, :confirm => t("labels.confirm_delete_customer"))}</td>)
          rsl << %(</tr>)
        end
      rsl << %(</tbody>)
    rsl << %(</table>)
    rsl << %(<div class="center">)
      rsl << bootstrap_will_paginate(customers, :params => { :controller => "/customers", :action => "index" }) rescue ""
    rsl << %(</div>)
    raw(rsl)
  end

end
