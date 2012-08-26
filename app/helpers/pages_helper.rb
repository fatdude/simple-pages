module PagesHelper
  def navigation(root)
    pages = Page.find_by_name(root).subtree.displayed_in_menu.published.includes(:controller_actions).to_depth(2).arrange(order: 'position asc')

    pages.map do |page, sub_pages|
      content_tag :ul, class: 'nav' do
        nav_link(sub_pages)
      end
    end.join.html_safe
  end

  def breadcrumbs
    if @breadcrumbs
      breadcrumbs = @breadcrumbs
    else
      if @page
        breadcrumbs = @page.ancestors
        breadcrumbs << @page
      end
    end

    if breadcrumbs
      content_tag :ul, class: 'breadcrumb' do
        breadcrumbs.map do |page|
          content_tag :li, class: ('active' if page == breadcrumbs.last) do
            page == breadcrumbs.last ? page.link : link_to(page.link, page_url(page)) + content_tag(:span, '/', class: 'divider')
          end
        end.join.html_safe
      end
    end
  end

  def page_url(page)
    if page.url?
      page.url
    else
      controller_action = page.controller_actions.first
      if controller_action
        url_for(controller: controller_action.controller, action: controller_action.action)
      else
        ''
      end
    end
  end

  def page_content(part='body')
    if @page
      page_part = @page.content(part)
      if page_part.filter == 0
        textilize page_part.content
      else
        page_part.content
      end
    end
  end

  protected

    def nav_link(sub_pages)
      sub_pages.map do |page, sub_pages|
        options = {}
        link_text, link_url = ''

        if sub_pages.any?
          options[:class] = 'dropdown-toggle'
          options[:'data-toggle'] = 'dropdown'
          link_text = "#{page.link} #{content_tag(:b, nil, class: 'caret')}".html_safe
          link_url = '#'
        else
          link_text = page.link
          link_url = page_url(page)
        end

        content_tag :li, class: ('dropdown' if sub_pages.any?) do
          link_to(link_text, link_url, options) + (sub_pages.any? ? content_tag(:ul, nav_link(sub_pages), class: 'dropdown-menu') : '')
        end
      end.join.html_safe
    end
end
