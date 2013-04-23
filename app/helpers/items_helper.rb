module ItemsHelper
  def draw_item_row parent, item
    meth = :"draw_#{parent.class.to_s.underscore}_row"
    rsl = send(meth, parent, item)
    rsl.html_safe
  end

  def draw_edit_item_row parent, item
    meth = :"draw_edit_#{parent.class.to_s.underscore}_row"
    rsl = send(meth, parent, item)
    rsl.html_safe
  end
end
