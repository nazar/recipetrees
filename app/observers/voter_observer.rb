class VoterObserver < ActiveRecord::Observer

  include VoterReputation

  observe Rating
  
  def after_create(rating)
    Achievement.transaction do
      VoterBadge.award_achievements_for(rating.user)
      VotesFiveStar.award_achievements_for(rating.user)
      VotesOneStar.award_achievements_for(rating.user)
      if rating.rateable_type == 'Recipe'
        VotesGoodRecipe.award_achievements_for(rating.rateable.user)
      end
      #reputation, one each for rater and ratee
      #ratee
      Reputation.process_reputation_for(rating)
      #rater
      process_voter_reputation(rating)
    end
  end

end