# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  $(document).on 'change', 'select.filter', ->
    textarea = $('#' + $(this).data('editor'))
    remove_editor textarea

    switch $(this).val()
      when '0' then add_wysiwyg textarea
      when '1' then add_html textarea

  $('textarea.simple-pages-editor[data-filter="html"]').each (i, textarea) ->
    add_html $(textarea)

  $('textarea.simple-pages-editor[data-filter="wysiwyg"]').each (i, textarea) ->
    add_wysiwyg $(textarea)

  $('ol.nested-sortable').nestedSortable
      disableNesting: 'no-nest'
      forcePlaceholderSize: true
      handle: 'i.icon-reorder'
      helper: 'clone'
      items: 'li'
      maxLevels: 0
      opacity: .6
      placeholder: 'placeholder'
      revert: 250
      tabSize: 25
      tolerance: 'pointer'
      toleranceElement: '> div'
      update: ->
        $('#simple-pages-revert-order').fadeIn()

  $('#simple-pages-save-order').click ->
    $.ajax
      data: $('ol.nested-sortable').nestedSortable('serialize');
      dataType:'script'
      url: '/admin/pages/save_order'
      type: 'put'

  $('#add-page-part').click ->
    name = prompt('New page part name').replace(/[^a-z0-9\-_]+/ig, '-')

    if name != ''
      if $('#' + name).length == 0
        new_id = new Date().getTime()
        content = $('.page-parts').data('fields').replace(/new_page_parts/g, new_id)
        $(this).parent().before('<li><a href="#' + name + '" data-toggle="tab" id="tab_' + name + '">' + name + '<i class="icon-remove-sign remove-page-part"></i></a></li>')
        $('#content .tab-content').append('<div class="tab-pane fade in active" id="' + name + '">' + content + '</div>')
        $('#' + name + ' input:first').val(name)
        add_wysiwyg $('#' + name + ' textarea')
        $('#tab_' + name).tab('show')
      else
        alert('Name already exists')
    else
      alert('You need to specify a name')

    false

  $('.remove-page-part').click ->
    if confirm 'Are you sure?'
      target = $(this).parent().attr('href')
      $(target + ' .destroy-page-part').val(1)
      $(this).parent().parent().fadeOut()
      $(target).fadeOut 800, ->
        $('.page-parts .nav-tabs li:visible').first().addClass('active')

add_html = (textarea) ->
  CodeMirror.fromTextArea document.getElementById(textarea.attr("id")),
    lineNumbers: true
    matchBrackets: true
    mode: 'text/html'
    theme: 'default'
  textarea.data('filter', 'html')

add_wysiwyg = (textarea) ->
  textarea.wysihtml5
    "font-styles": false # Font styling, e.g. h1, h2, etc. Default true
    "emphasis": true # Italics, bold, etc. Default true
    "lists": true # (Un)ordered lists, e.g. Bullets, Numbers. Default true
    "html": true # Button which allows you to edit the generated HTML. Default false
    "link": true # Button to insert a link. Default true
    "image": true # Button to insert an image. Default true
  textarea.data('filter', 'wysiwyg')

add_css = (textarea) ->
  CodeMirror.fromTextArea document.getElementById(textarea.attr("id")),
    lineNumbers: true
    matchBrackets: true
    mode: "css"

add_javascript = (textarea) ->
  CodeMirror.fromTextArea document.getElementById(textarea.attr("id")),
    lineNumbers: true
    matchBrackets: true
    mode: "javascript"

remove_editor = (textarea) ->
  switch textarea.data('filter')
    when 'html'
      textarea.show().next().remove()
    when 'wysiwyg'
      parent = textarea.parent()
      textarea.show()
      parent.html textarea