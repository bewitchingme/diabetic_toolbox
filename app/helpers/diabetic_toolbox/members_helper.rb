module DiabeticToolbox
  #:enddoc:
  module MembersHelper
    ##
    # This tries to be as lean as possible, assigning nothing and performing
    # nothing unless the member is signed in.
    def render_member_overview
      locals = if member_signed_in?
        {
          recipes:      current_member.recipes.size,
          since:        current_member.created_at.localtime.strftime( '%D' ),
          karma:        current_member.karma,
          achievements: current_member.achievements.size
        }
      end

      render partial: 'diabetic_toolbox/members/member_overview', locals: locals if member_signed_in?
    end
  end
end
