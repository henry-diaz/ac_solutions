module ContactsHelper

  def draw_contacts_table
    rsl = ""
    return rsl unless customer

      rsl << %(<table class="table table-striped table-condensed">)
        rsl << %(<thead>)
          rsl << %(<tr>)
            rsl << %(<th>#{t("labels.status")}</th>)
            rsl << %(<th>#{t("labels.first_name")}</th>)
            rsl << %(<th>#{t("labels.last_name")}</th>)
            #rsl << %(<th>#{t("labels.charge")}</th>)
            rsl << %(<th>#{t("labels.phone")}</th>)
            rsl << %(<th>#{t("labels.email")}</th>)
            rsl << %(<th>&nbsp;</th>)
          rsl << %(</tr>)
        rsl << %(</thead>)
        rsl << %(<tbody>)
        customer.contacts.each do |contact|
          rsl << draw_contact_row(customer, contact)
        end
        rsl << %(</tbody>)
        #rsl << %(<tfoot><tr><td colspan=7></td></tr>)
        rsl << %(<tfoot><tr><td colspan=6></td></tr>)
        rsl << render(partial: "contacts/new", locals: { customer: customer })
        rsl << %(</tfoot>)
      rsl << %(</table>)
      rsl << %(<div class="table-separator"></div>)
    raw(rsl)
  end

  def draw_contact_row customer, contact
    rsl = ""
    return rsl unless customer && contact
    rsl << %(<tr class="row-grid" data-id="#{contact.id}">)
      rsl << %(<td>#{contact.status}</td>)
      rsl << %(<td>#{contact.first_name}</td>)
      rsl << %(<td>#{contact.last_name}</td>)
      #rsl << %(<td>#{contact.charge_name}</td>)
      rsl << %(<td>#{contact.phone}</td>)
      rsl << %(<td>#{contact.email}</td>)
      rsl << %(<td>#{link_to(t("labels.edit"), edit_customer_contact_url(customer, contact), :class => "edit_link", :remote => true)}</td>)
    rsl << %(</tr>)
    rsl.html_safe
  end

  def draw_edit_contact_row customer, contact
    rsl = ""
    rsl << %(<tr class="row-grid form-container" data-id="#{contact.id}" data-edit=true>)
    rsl << %(<td>#{check_box("contact", "active", { checked: contact.active == 1 ? true : nil } , 1, 0)}</td>)
    rsl << %(<td>#{text_field_tag("contact[first_name]", contact.first_name, :class => "input-medium")}</td>)
    rsl << %(<td>#{text_field_tag("contact[last_name]", contact.last_name, :class => "input-medium")}</td>)
    #rsl << %(<td>#{collection_select(:contact, :charge_id, Charge.all, :id, :name, { include_blank: t("labels.select"), selected: contact.charge_id }, { style: "margin: 0;", class: "input-medium" })}</td>)
    rsl << %(<td>#{text_field_tag("contact[phone]", contact.phone, :class => "input-small")}</td>)
    rsl << %(<td>#{text_field_tag("contact[email]", contact.email, :class => "input-small")}</td>)
    rsl << %(<td>#{link_to(t("labels.update"), "javascript:;", class: "save_link submit-me", data: { action: customer_contact_path(customer, contact), method: :put })}</td>)
    rsl << %(</tr>)
    rsl.html_safe
  end

end
