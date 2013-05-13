module ServicesHelper

  def draw_services services
    rsl = ""
    rsl << %(<div class="clearfix">#{link_to(t("labels.add"), new_service_url, :class => "add_link pull-right")}</div>)
    rsl << %(<table class="table table-striped table-condensed" style="margin-top: 3px;">)
      rsl << %(<thead>)
        rsl << %(<tr>)
          rsl << %(<th>#{sort_link(@q, :active, t("labels.status"), { :controller => '/services', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :code, t("labels.code"), { :controller => '/services', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :name, t("labels.name"), { :controller => '/services', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :unit_price, t("labels.base_price"), { :controller => '/services', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :description, t("labels.description"), { :controller => '/services', :action => 'index' })}</th>)
          rsl << %(<th colspan=2>&nbsp;</th>)
        rsl << %(</tr>)
      rsl << %(</thead>)
      rsl << %(<tfoot><tr><td colspan=7></td></tr><tr><td class="table-separator" colspan=7>&nbsp;</td></tr></tfoot>)
      rsl << %(<tbody>)
        services.each do |s|
          rsl << draw_service(s)
        end
      rsl << %(</tbody>)
    rsl << %(</table>)
    rsl << %(<div class="center">)
      rsl << bootstrap_will_paginate(services, :params => { :controller => "/services", :action => "index" }) rescue ""
    rsl << %(</div>)
    raw(rsl)
  end

  def draw_service service
    rsl = ""
    rsl << %(<tr data-id="#{service.id}">)
      rsl << %(<td>#{service.status}</td>)
      rsl << %(<td>#{service.code}</td>)
      rsl << %(<td>#{service.name}</td>)
      rsl << %(<td class="right">#{service.unit_price}</td>)
      rsl << %(<td>#{service.description}</td>)
      rsl << %(<td>#{link_to(t("labels.edit"), edit_service_url(service), :class => "edit_link")}</td>)
      rsl << %(<td>#{link_to(service.active? ? t("labels.deactivate") : t("labels.activate"), toggle_service_url(service), :class => "#{service.active? ? "deactivate_link" : "activate_link"}", :remote => true)}</td>)
    rsl << %(</tr>)
    raw(rsl)
  end

end
