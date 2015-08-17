
#region SettingMutations Class
class @SettingMutations
  watch:  null
  mutate: null

  config: ->
    @watch  = glucometer: {
      combo: $('#setting_glucometer_measure_type')
    },
    intake: {
      combo: $('#setting_intake_measure_type')
    }

    @mutate = window.mutations
    true

  constructor: ->
    @config()
    @

  evolve: ->
    combos           = @watch
    change           = @mutate
    increments_addon = $('#increments_per_addon')
    correction_addon = $('#correction_begins_at_addon')
    intake_addon     = $('#intake_measurement_addon')
    calculables      = $('#settings_for_calculation')

    @watch.glucometer.combo.change (ev) ->
      value      = $(this).val()
      correction = change.glucometer.correction_begins_at[value]
      increments = change.glucometer.increments_per[value]

      correction_addon.html correction if $(this)[0].selectedIndex > 0 || $(this).closest('form').hasClass('edit_setting')
      increments_addon.html increments if $(this)[0].selectedIndex > 0 || $(this).closest('form').hasClass('edit_setting')

      if calculables and combos.glucometer.combo[0].selectedIndex > 0 and combos.intake.combo[0].selectedIndex > 0
        calculables.fadeTo 100, 1
      else
        calculables.fadeTo 100, 0
    @

    @watch.intake.combo.change (ev) ->
      value  = $(this).val()
      intake = change.intake.intake_measurement[value]

      intake_addon.html intake if $(this)[0].selectedIndex > 0 || $(this).closest('form').hasClass('edit_setting')

      if calculables and combos.glucometer.combo[0].selectedIndex > 0 and combos.intake.combo[0].selectedIndex > 0
        $('#settings_for_calculation').fadeTo 100, 1
      else
        $('#settings_for_calculation').fadeTo 100, 0


#endregion
