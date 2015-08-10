module DiabeticToolbox::Concerns::Voter
  extend ActiveSupport::Concern

  class_methods do
    attr_accessor :karmic_objects

    def has_karma(voteable_type, options = {})
      self.karmic_objects ||= {}
      self.karmic_objects[voteable_type.to_s.classify.constantize] = [ (options[:as] ? options[:as].to_s.foreign_key : self.name.foreign_key), [ (options[:weight] || 1) ].flatten.map(&:to_f) ]
    end
  end

  instance_methods do
  end

  ##
  # A lot of this was ripped out of the thumbs_up gem, which didn't support use
  # in a namespaced engine very well.
  included do
    has_many      :votes, as: :voter, dependent: :destroy, class_name: 'DiabeticToolbox::Vote'

    def karma(options = {})
      self.class.base_class.karmic_objects.collect do |object, attr|
        v = object.where(["#{self.class.base_class.table_name}.#{self.class.base_class.primary_key} = ?", self.id])
        v = v.joins("INNER JOIN #{DiabeticToolbox::Vote.table_name} ON #{DiabeticToolbox::Vote.table_name}.voteable_type = '#{object.to_s}' AND #{DiabeticToolbox::Vote.table_name}.voteable_id = #{object.table_name}.#{object.primary_key}")
        v = v.joins("INNER JOIN #{self.class.base_class.table_name} ON #{self.class.base_class.table_name}.#{self.class.base_class.primary_key} = #{object.table_name}.#{attr[0]}")
        upvotes = v.where(["#{DiabeticToolbox::Vote.table_name}.vote = ?", true])
        downvotes = v.where(["#{DiabeticToolbox::Vote.table_name}.vote = ?", false])
        if attr[1].length == 1 # Only count upvotes, not downvotes.
          (upvotes.count.to_f * attr[1].first).round
        else
          (upvotes.count.to_f * attr[1].first - downvotes.count.to_f * attr[1].last).round
        end
      end.sum
    end

    def vote_count(for_or_against = :all)
      v = DiabeticToolbox::Vote.where(voter_id: id).where(voter_type: self.class.base_class.name)
      v = case for_or_against
            when :all   then v
            when :up    then v.where(vote: true)
            when :down  then v.where(vote: false)
          end
      v.count
    end

    def voted_for?(voteable)
      voted_which_way?(voteable, :up)
    end

    def voted_against?(voteable)
      voted_which_way?(voteable, :down)
    end

    def voted_on?(voteable)
      0 < DiabeticToolbox::Vote.where(
          voter_id:      self.id,
          voter_type:    self.class.base_class.name,
          voteable_id:   voteable.id,
          voteable_type: voteable.class.base_class.name
      ).count
    end

    def vote_for(voteable)
      self.vote(voteable, { direction: :up, exclusive: false })
    end

    def vote_against(voteable)
      self.vote(voteable, { direction: :down, exclusive: false })
    end

    def vote_exclusively_for(voteable)
      self.vote(voteable, { direction: :up, exclusive: true })
    end

    def vote_exclusively_against(voteable)
      self.vote(voteable, { direction: :down, exclusive: true })
    end

    def vote(voteable, options = {})
      raise ArgumentError, "you must specify :up or :down in order to vote" unless options[:direction] && [:up, :down].include?(options[:direction].to_sym)
      if options[:exclusive]
        self.unvote_for(voteable)
      end
      direction = (options[:direction].to_sym == :up)
      # create! does not return the created object
      v = DiabeticToolbox::Vote.new(vote: direction, voteable: voteable, voter: self)
      v.save!
      v
    end

    def unvote_for(voteable)
      DiabeticToolbox::Vote.where(
          voter_id:      self.id,
          voter_type:    self.class.base_class.name,
          voteable_id:   voteable.id,
          voteable_type: voteable.class.base_class.name
      ).map(&:destroy)
    end

    alias_method :clear_votes, :unvote_for

    def voted_which_way?(voteable, direction)
      raise ArgumentError, "expected :up or :down" unless [:up, :down].include?(direction)
      0 < DiabeticToolbox::Vote.where(
          :voter_id => self.id,
          :voter_type => self.class.base_class.name,
          :vote => direction == :up ? true : false,
          :voteable_id => voteable.id,
          :voteable_type => voteable.class.base_class.name
      ).count
    end

    def voted_how?(voteable)
      votes = DiabeticToolbox::Vote.where(
          voter_id:      self.id,
          voter_type:    self.class.base_class.name,
          voteable_id:   voteable.id,
          voteable_type: voteable.class.base_class.name
      ).map(&:vote) #in case votes is premitted to be duplicated
      if votes.count == 1
        votes.first
      elsif votes.count == 0
        nil
      else
        votes
      end
    end

  end

end