module DiabeticToolbox
  module ApplicationHelper
    def render_member_navigation(current_waypoint, stop = nil)
      render partial: 'diabetic_toolbox/members/member_navigation', locals: { pathway: DiabeticToolbox::Navigator.course(:dashboard), active: current_waypoint, stop: stop }
    end

    def show_member_gravatar(size = 22)
      image_tag "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(current_member.email.downcase)}?s=#{size}&d=mm", class: 'img-circle'
    end

    def brand_location
      default_path = root_path

      if member_signed_in?
        default_path = setup_path unless current_member.configured?
        default_path = member_dashboard_path
      end
      link_to t('navigation.brand'), default_path, class: 'navbar-brand'
    end

    def flash_messages
      return '' if flash.count.eql? 0

      render partial: 'common/flash'
    end

    def intake_type(setting)
      unless setting.new_record?
        return t('views.settings.carbohydrates') if setting.intake_measure_type.to_sym.eql? :carbohydrates
        return t('views.settings.calories') if setting.intake_measure_type.to_sym.eql? :calories
      end
    end

    def glucometer_type(setting, addon_for_increment = false)
      unless setting.new_record?
        return t('views.settings.mmol') if setting.mmol? && !addon_for_increment
        return t('views.settings.mmol_units') if setting.mmol? && addon_for_increment
        return t('views.settings.mg') if setting.mg? && !addon_for_increment
        return t('views.settings.mg_units') if setting.mg? && addon_for_increment
      end
    end
  end
end
