module Admin::PagesHelper
  def nested_pages(pages)
    pages.map do |page, sub_pages|
      render(page, sub_pages: sub_pages)
    end.join.html_safe
  end

  def page_part_fields(f)
    fields = f.simple_fields_for(:page_parts, PagePart.new, :child_index => "new_page_parts") do |builder|
      safe_concat(render('page_part_fields', :f => builder))
    end
    fields
  end 
end
