module DiabeticToolbox
  # = Navigator
  #
  # The Navigator module assists in storing navigation.  It assumes that
  # top-level navigation elements (waypoints on the pathway) will be
  # paired with an icon but that rest stops will not.  As follows:
  #
  #   Navigator.chart :members do |pathway|
  #     pathway.waypoint :sym, 'Label', 'icon', helper_path do |stop|
  #       stop.attraction :sub_sym, 'Label', helper_path
  #     end
  #   end
  #
  #   Navigator.course(:members).waypoints.each do |waypoint,anchor|
  #     # waypoint       = :sym
  #     # anchor[:sign]  = 'Label'
  #     # anchor[:icon]  = 'icon'
  #     # anchor[:route] = helper_path
  #   end
  #
  # See: DiabeticToolbox::ApplicationController#deploy_member_navigation
  #
  module Navigator
    #:enddoc:
    #region Module Methods
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
    #endregion

    #region Pathway
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
    #endregion

    #region Rest Stop
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
    #endregion
  end
end