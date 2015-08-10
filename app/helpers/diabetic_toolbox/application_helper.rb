module DiabeticToolbox
  module ApplicationHelper
    def render_member_navigation(active)
      render partial: 'diabetic_toolbox/members/member_navigation', locals: { tabs: @tabs, active: active }
    end

    def show_member_gravatar(size = 22)
      image_tag "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(current_member.email.downcase)}?s=#{size}&d=mm", class: 'img-circle'
    end

    def brand_location
      default_path = root_path
      default_path = member_dashboard_path(current_member) if member_signed_in?
      link_to t('navigation.brand'), default_path, class: 'navbar-brand'
    end
  end
end
