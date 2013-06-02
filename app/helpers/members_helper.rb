module MembersHelper

  def draw_members members
    rsl = ""
    rsl << %(<div class="clearfix">#{link_to(t("labels.add"), new_member_url, :class => "add_link pull-right")}</div>)
    rsl << %(<table class="table table-striped table-condensed" style="margin-top: 3px;">)
      rsl << %(<thead>)
        rsl << %(<tr>)
          rsl << %(<th>#{sort_link(@q, :email, t("labels.email"), { :controller => '/members', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :first_name, t("labels.first_name"), { :controller => '/members', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :last_name, t("labels.last_name"), { :controller => '/members', :action => 'index' })}</th>)
          rsl << %(<th>#{sort_link(@q, :role, t("labels.role"), { :controller => '/members', :action => 'index' })}</th>)
          rsl << %(<th colspan=2>&nbsp;</th>)
        rsl << %(</tr>)
      rsl << %(</thead>)
      rsl << %(<tfoot><tr><td colspan=6></td></tr><tr><td class="table-separator" colspan=6>&nbsp;</td></tr></tfoot>)
      rsl << %(<tbody>)
        members.each do |u|
          rsl << %(<tr>)
            rsl << %(<td>#{u.email}</td>)
            rsl << %(<td>#{u.first_name}</td>)
            rsl << %(<td>#{u.last_name}</td>)
            rsl << %(<td>#{u.get_role}</td>)
            rsl << %(<td>#{link_to(t("labels.edit"), edit_member_url(u), :class => "edit_link")}</td>)
            rsl << %(<td>#{link_to(t("labels.delete"), member_url(u), :class => "remove_link", :method => :delete, :confirm => t("labels.confirm_delete_user")) unless current_user.id == u.id}</td>)
          rsl << %(</tr>)
        end
      rsl << %(</tbody>)
    rsl << %(</table>)
    rsl << %(<div class="center">)
      rsl << bootstrap_will_paginate(members, :params => { :controller => "/members", :action => "index" }) rescue ""
    rsl << %(</div>)
    raw(rsl)
  end

end
