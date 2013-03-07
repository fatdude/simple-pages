module PagesHelper
  def navigation(root)
    pages = Page.find_by_name(root).subtree(to_depth: 3).displayed_in_menu.published.includes(:controller_actions).arrange(order: 'position asc')

    content_tag :ul, class: 'nav' do
      pages.map do |page, sub_pages|
        content_tag :li, class: ('active' if page.id == @page.try(:id)) do
          link_to(page.link, page_url(page))
        end.concat nav_link(sub_pages, page.depth)
      end.join.html_safe
    end
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
      content_tag :div, class: 'page-content' do
        page_part = @page.content(part.to_s)
        if page_part
          if page_part.filter == 0
            sanitize page_part.content, tags: %w{ b i ul li ol blockquote u br }
          else
            page_part.content
          end
        end
      end
    end
  end

  def page_css
    if @page
      "<style>#{@page.css}</style>".html_safe
    end
  end

  def page_js
    if @page
      "<script type=\"text/javascript\">#{@page.js}</script>".html_safe
    end
  end

  protected

    def nav_link(sub_pages, root_depth, parent=nil)
      sub_pages.map do |page, sub_pages|

        relative_depth = page.depth - root_depth
        options = {}
        link_text, link_url = ''

        if relative_depth == 1
          active = page.id == @page.try(:id) || page.descendant_ids.include?(@page.try(:id))
        end

        if sub_pages.any?
          if relative_depth == 1 # First level
            options[:class] = 'dropdown-toggle'
            options[:'data-toggle'] = 'dropdown'
            link_text = "#{page.link} #{content_tag(:b, nil, class: 'caret')}".html_safe
            link_url = '#'
          else
            link_text = page.link
            link_url = '#'
          end
        else
          link_text = page.link
          link_url = page_url(page)
        end

        if sub_pages.any?
          li_class = relative_depth == 1 ? 'dropdown' : 'dropdown-submenu'
        end

        content_tag :li, class: "#{'active' if active} #{li_class}" do
          link_to(link_text, link_url, options) + (sub_pages.any? ? content_tag(:ul, nav_link(sub_pages, root_depth), class: 'dropdown-menu') : '')
        end
      end.join.html_safe
    end
end
