# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#dob-picker').length
    $('#dob-picker').datetimepicker format: 'YYYY-MM-DD', viewMode: 'years'
    $('#dob-picker, #dob-addon').on 'click', () ->
      $('#dob-picker').data('DateTimePicker').toggle()
      true
  true
