@organize_sub_questions = ->
  # TODO: Do this for dropdowns too
  $('input[type=radio]').click ->
    sibling_options = $("input[name='#{$(this).attr('name')}']").not(this)
    sibling_options.each (index, option) ->
      hide_sub_questions_of(option)
    show_sub_questions_of($(this))

  $('select').change ->
    option = this.options[this.selectedIndex]
    sibling_options = $(this.options).not(option)
    sibling_options.each (index, option) ->
      hide_sub_questions_of(option)
    show_sub_questions_of(option)

  $('form.formtastic').submit -> remove_hidden_sub_questions()


  initialize = ->
    show_sub_questions_of(option) for option in $('input[type=radio]:checked,option:checked')

  show_sub_questions_of = (option) ->
    for sub_question in sub_questions_for(option)
      $(sub_question).removeClass('hidden')
      $(sub_question).css('margin-left', $(sub_question).data('nesting-level')*15)

  hide_sub_questions_of = (option) ->
    sub_questions_for(option).each (index) ->
      sub_question = $(this)
      clear_content_of sub_question
      sub_question.addClass('hidden')
      hide_sub_questions_of(option) for option in sub_question.find('input[type=radio],option')

  clear_content_of = (sub_question) ->
    $(sub_question).find('input[type!=hidden]').val('')
    $(sub_question).find('textarea').val('') # For multi_line questions
    $(sub_question).find('input').prop('checked', false) # For radio_buttons and check_boxes
    $(sub_question).find('option').prop('selected', false) # For drop_downs
    $(sub_question).find('.rating').find('li.hidden').children('input').val('') # Rating question
    $(sub_question).find('.star').raty('cancel')

  sub_questions_for = (option) ->
    $('.sub_question').filter ->
      sub_question = $(this)
      $(option).data('option-id') == sub_question.data('parent-id')

  remove_hidden_sub_questions = () ->
    $('.hidden.sub_question').each ->
      hidden_field_name = $(this).find('input[type=hidden]').attr('name').replace('[question_id]', '[id]')
      $(this).remove()
      $("[name=\"#{hidden_field_name}\"]").remove()

  initialize()
