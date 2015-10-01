module DiabeticToolbox
  #:enddoc:
  module Navigator
    def self.chart(destination, &block)
      @pathways ||= {}

      if !@pathways.has_key? destination
        @pathways[destination] = Pathway.new
        block.call @pathways[destination]
      end
    end

    def self.course(destination)
      @pathways[destination]
    end

    class Pathway
      def initialize
        @waypoints  = {}
        @rest_stops = {}
      end

      def waypoints
        @waypoints
      end

      def stops(name)
        @rest_stops[name]
      end

      def waypoint(name, sign, icon, route, &block)
        @waypoints[name] = {sign: sign, icon: icon, route: route}

        if block_given?
          @rest_stops[name] ||= RestStop.new
          block.call @rest_stops[name]
        end
      end
    end

    class RestStop
      def initialize
        @locations = {}
      end

      def attraction(name, label, route)
        @locations[name] = {label: label, route: route}
      end

      def locations
        @locations
      end
    end
  end
end