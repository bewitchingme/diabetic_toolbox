# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require 'diabetic_toolbox/settings/locale/mutations.en'
#= require 'diabetic_toolbox/settings/mutations'

$ ->
  setting_mutations = new SettingMutations().evolve()
  true
