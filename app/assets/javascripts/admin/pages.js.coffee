# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

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
    target = $(this).parent().attr('href')
    $(target + ' .destroy-page-part').val(1)
    $(this).parent().parent().fadeOut()
    $(target).fadeOut 800, ->
      console.debug $('.page-parts .nav-tabs li:visible').first()
      $('.page-parts .nav-tabs li:visible').first().addClass('active')
