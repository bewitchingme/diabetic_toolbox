# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#test-time-picker').length
    $('#test-time-picker').datetimepicker format: 'YYYY-MM-DD hh:mm A'
    $('#test-time-picker, #test-time-addon').on 'click', () ->
      $('#test-time-picker').data('DateTimePicker').toggle()
      true
  true
