#:enddoc:
module DiabeticToolbox::Concerns::Voteable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, as: :voteable, dependent: :destroy, class_name: 'DiabeticToolbox::Vote'

    def _votes_on
      self.votes
    end

    def votes_for
      self._votes_on.where(:vote => true).count
    end

    def votes_against
      self._votes_on.where(:vote => false).count
    end

    def percent_for
      (votes_for.to_f * 100 / (self._votes_on.size + 0.0001)).round
    end

    def percent_against
      (votes_against.to_f * 100 / (self._votes_on.size + 0.0001)).round
    end

    def plusminus
      respond_to?(:plusminus_tally) ? plusminus_tally : (votes_for - votes_against)
    end

    def votes_count
      _votes_on.size
    end

    def voters_who_voted
      _votes_on.map(&:voter).uniq
    end

    def voters_who_voted_for
      _votes_on.where(:vote => true).map(&:voter).uniq
    end

    def voters_who_voted_against
      _votes_on.where(:vote => false).map(&:voter).uniq
    end

    def voted_by?(voter)
      0 < DiabeticToolbox::Vote.where(
          voteable_id:   self.id,
          voteable_type: self.class.base_class.name,
          voter_id:      voter.id
      ).count
    end
  end

end