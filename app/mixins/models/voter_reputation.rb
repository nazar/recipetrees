module VoterReputation

  def process_voter_reputation(rating)
    unless rating.user.blank?
      reason = case rating.rating.to_i
        when 1 then 'gave a 1 out of 5 rating'
        when 3..5 then "gave a #{rating.rating} out of 5 rating"
      end
      score = case rating.rating.to_i
        when 1 then -2
        else
          rating.rating
        end
      Reputation.process_reputation_for(rating, rating.user, reason, score)
    end
  end

end