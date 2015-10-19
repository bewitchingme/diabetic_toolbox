module DiabeticToolbox
  # = MemberDashboard
  #
  # The MemberDashboard class provides data and configuration for the
  # chart kick library currently; ultimately anything displayed on the
  # dashboard should have its data organized here.
  #
  #   MemberDashboard.history(member, period) #=> Member readings history, 60 days worth
  #   MemberDashboard.chartkick_library       #=> Interface settings for chart kick
  #
  class MemberDashboard
    #:enddoc:
    #region Static
    def self.history(member, travel = (Time.now - 30.days))
      history = member.readings.where(test_time: travel..(Time.now)).order(test_time: :asc)
      history.to_a.each_with_object({}){ |r,h| h[Time.zone.parse(r.test_time.to_s)] = r.glucometer_value }
    end

    def self.chartkick_library
      {
        lineWidth: 2,
        curveType: 'function',
        backgroundColor: {
          fill: '#EFF3F4',
          stroke: '#608AB5',
          strokeWidth: 1
        },
        fontName: 'Merriweather',
        title: I18n.t('diabetic_toolbox.member_dashboard.thirty_day_history'),
        titleTextStyle: {
          color: '#21485C'
        },
        tooltip: {
          backgroundColor: '#222',
          color: '#21485C'
        },
        colors: ['#5299C7'],
        hAxis: {
          baselineColor: '#21485C',
          titleTextStyle: {
            color: '#21485C'
          },
          title: I18n.t('diabetic_toolbox.member_dashboard.date'),
          gridlines: {
            count: 6,
            color: '#21485C'
          }
        },
        vAxis: {
          textStyle: {
            color: '#21485C'
          },
          titleTextStyle: {
            color: '#21485C'
          },
          title: I18n.t('diabetic_toolbox.member_dashboard.reading'),
          gridlines: {
              count: 4,
              color: '#21485C'
          }
        }
      }
    end
    #endregion
  end
end