# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  $('select.filter').on 'change', ->
    textarea = $('#' + $(this).data('editor'))
    remove_editor($(this).data('editor'))

    switch $(this).val()
      when '0' then add_markdown $(this).data('editor')
      when '1' then add_html $(this).data('editor')

  $('textarea.editor[data-filter="html"]').each (i, textarea) ->
    add_html($(textarea).attr('id'))  

  $('textarea.editor[data-filter="markdown"]').each (i, textarea) ->
    add_markdown($(textarea).attr('id'))

  $('ol.nested-sortable').nestedSortable
      disableNesting: 'no-nest'
      forcePlaceholderSize: true
      handle: 'div'
      helper: 'clone'
      items: 'li'
      maxLevels: 0
      opacity: .6
      placeholder: 'placeholder'
      revert: 250
      tabSize: 25
      tolerance: 'pointer'
      toleranceElement: '> div'

  $('.save-positions').click ->
    serialized = $('ol.nested-sortable').nestedSortable('serialize');
    console.debug serialized

    $.ajax
      data: serialized
      dataType:'script'
      url: '/admin/pages/save_order'
      type: 'put'

  $('#add-page-part').click ->
    name = prompt('New page part name').replace(/[^a-z0-9\-_]+/ig, '-')

    if name != ''
      if $('#' + name).length == 0        
        new_id = new Date().getTime()        
        content = $('.page-parts').data('fields').replace(/new_page_parts/g, new_id)

        $('.in, .active').removeClass('in active')
        $('.tab-content').append('<div class="tab-pane fade in active" id="' + name + '">' + content + '</div>')  
        $('#' + name + ' input:first').val(name)
        $(this).parent().before('<li><a href="' + name + '" data-toggle="tab" id="tab_' + name + '">' + name + '<i class="icon-remove-sign remove-page-part"></i></a></li>')
        $('#' + name + ' textarea').markedit()
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

add_html = (id) ->
  CodeMirror.fromTextArea document.getElementById(id),
    lineNumbers: true
    matchBrackets: true
    mode: 'text/html'
    theme: 'default'
  $('#' + id).data('filter', 'html').next().addClass('span10')

add_markdown = (id) ->
  $('#' + id).markedit
    postload: ->
      $('#' + id).parent().addClass('span10')
  $('#' + id).data('filter', 'markdown')

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

remove_editor = (id) ->
  textarea = $('#' + id)

  switch textarea.data('filter')
    when 'html' then textarea.show().next().remove()
    when 'markdown'
      parent = textarea.parent().parent()
      textarea.show().appendTo(parent)
      textarea.prev().remove()
