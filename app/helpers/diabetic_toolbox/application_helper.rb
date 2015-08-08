module DiabeticToolbox
  module ApplicationHelper
    def render_member_navigation(active)
      render partial: 'diabetic_toolbox/members/member_navigation', locals: { tabs: @tabs, active: active }
    end

    def show_member_gravatar
      image_tag "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(current_member.email.downcase)}?s=22&d=mm", class: 'img-circle'
    end
  end
end
