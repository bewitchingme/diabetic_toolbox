module DiabeticToolbox
  class MemberDashboard
    def self.history(member, travel = (Time.now - 60.days))
      history = member.readings.where(test_time: travel..(Time.now)).order(test_time: :asc)
      history.to_a.each_with_object({}){ |r,h| h[Time.zone.parse(r.test_time.to_s)] = r.glucometer_value }
    end

    def self.chartkick_library
      {
        lineWidth: 2,
        curveType: 'function',
        backgroundColor: '#333',
        fontName: 'Merriweather',
        title: "60 Day History",
        titleTextStyle: {
          color: '#CACACA'
        },
        tooltip: {
          backgroundColor: '#222',
          color: '#CACACA'
        },
        colors: ['#4dc8df'],
        hAxis: {
          baselineColor: '#CACACA',
          titleTextStyle: {
            color: '#CACACA'
          },
          title: "Date",
          gridlines: {
            count: 6,
            color: "#5A5A5A"
          }
        },
        vAxis: {
          textStyle: {
            color: '#CACACA'
          },
          titleTextStyle: {
            color: '#CACACA'
          },
          title: "Reading",
          gridlines: {
              count: 4,
              color: "#5A5A5A"
          }
        }
      }
    end
  end
end