module ApplicationHelper
  def draw_main_header
    rsl = ""
    rsl << %(<div id="main-header" class="clearfix">)
      rsl << %(<div class="logos">)
        rsl << link_to(image_tag("logo-mini.png", :alt => t("labels.ac_solutions")), root_url, :title => t("labels.ac_solutions"))
      rsl << %(</div>)
      rsl << %(<div class="menu-login">)
        rsl << %(<ul class="unstyled">)
          rsl << %(<li class="dropdown" id="menu-login">)
            rsl << %(#{t("labels.welcome")}, )
            rsl << %(<a class="dropdown-toggle" data-toggle="dropdown" href="#menu-login">#{current_user.full_name}<b class="caret"></b></a>)
            rsl << %(<ul class="dropdown-menu">)
              rsl << %(<li>#{link_to(t("labels.leave"), destroy_user_session_path, :method => :delete)}</li>)
            rsl << %(</ul>)
          rsl << %(</li>)
        rsl << %(</ul>)
      rsl << %(</div>)
      unless controller_name == "home"
        rsl << %(<div class="menu-shortcuts clearfix">)
          if current_user.role?(:admin)
            rsl << link_to(members_url, :class => "shortcut #{controller_name == "members" ? "active" : ""} #{current_user.role}", :title => t("labels.manage_users")) do
                     image_tag("modules/users-icon-small.png", :alt => t("labels.manage_users")) + "<br>".html_safe + t("labels.users")
                   end
          end
          rsl << link_to(customers_url, :class => "shortcut #{controller_name == "customers" ? "active" : ""} #{current_user.role}", :title => t("labels.manage_customers")) do
                   image_tag("modules/customers-icon-small.png", :alt => t("labels.manage_customers")) + "<br>".html_safe + t("labels.customers")
                 end
          rsl << link_to(skus_url, :class => "shortcut #{controller_name == "skus" ? "active" : ""} #{current_user.role}", :title => t("labels.manage_materials_and_products")) do
                   image_tag("modules/stock-icon-small.png", :alt => t("labels.manage_materials_and_products")) + "<br>".html_safe + t("labels.goods")
                 end
          rsl << link_to(services_url, :class => "shortcut #{controller_name == "services" ? "active" : ""} #{current_user.role}", :title => t("labels.manage_services")) do
                   image_tag("modules/services-icon-small.png", :alt => t("labels.manage_services")) + "<br>".html_safe + t("labels.services")
                 end
          rsl << link_to(purchases_url, :class => "shortcut #{controller_name == "purchases" ? "active" : ""} #{current_user.role}", :title => t("labels.shopping")) do
                   image_tag("modules/purchases-icon-small.png", :alt => t("labels.shopping")) + "<br>".html_safe + t("labels.shopping")
                 end
          rsl << link_to(sales_url, :class => "shortcut #{controller_name == "sales" ? "active" : ""} #{current_user.role}", :title => t("labels.sales")) do
                   image_tag("modules/sales-icon-small.png", :alt => t("labels.sales")) + "<br>".html_safe + t("labels.sales")
                 end
          rsl << link_to(appointments_url, :class => "shortcut #{controller_name == "appointments" ? "active" : ""} #{current_user.role}", :title => t("labels.appointments")) do
                   image_tag("modules/appointments-icon-small.png", :alt => t("labels.appointments")) + "<br>".html_safe + t("labels.appointments")
                 end
          rsl << link_to(reports_url, :class => "shortcut #{controller_name == "reports" ? "active" : ""} #{current_user.role}", :title => t("labels.reports")) do
                   image_tag("modules/reports-icon-small.png", :alt => t("labels.reports")) + "<br>".html_safe + t("labels.reports")
                 end
        rsl << %(</div>)
      end
    rsl << %(</div>)
    rsl.html_safe
  end

  def draw_errors object
    rsl = ""
    if object.errors.any?
      rsl << %(<div class = "alert alert-error">)
      rsl << %(<button class="close" type="button" data-dismiss="alert">&times;</button>)
      rsl << %(<strong>#{t("labels.error_save", :count => object.errors.count)}:</strong>)
      rsl << %(<ul>)
      object.errors.full_messages.each do |msg|
        rsl << %(<li>#{msg}</li>)
      end
      rsl << %(</ul></div>)
    end
    rsl.html_safe
  end

  def draw_flash_messages
    rsl = ""
    if flash[:notice]
      rsl << %(<div class="alert alert-success"><button class="close" type="button" data-dismiss="alert">&times;</button>#{flash[:notice]}</div>)
    end
    if flash[:alert] or params[:alert]
      rsl << %(<div class="alert alert-error"><button class="close" type="button" data-dismiss="alert">&times;</button>#{flash[:alert] || params[:alert]}</div>)
    end
    flash.discard
    rsl.html_safe
  end
end
