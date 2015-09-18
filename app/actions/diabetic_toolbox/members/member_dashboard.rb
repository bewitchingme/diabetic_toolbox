module DiabeticToolbox
  class MemberDashboard
    def self.history(member, travel = (Time.now - 60.days))
      history = member.readings.where(test_time: travel..(Time.now)).order(test_time: :asc)
      history.to_a.each_with_object({}){ |r,h| h[Time.zone.parse(r.test_time.to_s)] = r.glucometer_value }
    end

    def self.chartkick_library
      { fontName: 'Merriweather', title: "60 Day History", hAxis: {title: "Date", gridlines: { count: 3, color: "#DDD" } }, vAxis: {title: "Reading" } }
    end
  end
end