class Reputation < ActiveRecord::Base

  belongs_to :user
  belongs_to :reputable, :polymorphic => true


  #class methods

  def self.process_reputation_for(objekt, user = nil, reason = nil, score = nil)
    score ||= get_score(objekt).to_i
    if score != 0
      user ||= get_user_from_object(objekt)
      reason ||= get_reason(objekt)
      unless user.blank?
        reputation = Reputation.new(:user_id => user.id, :reason => reason, :reputation => score, :reputable => objekt)
        #do user
        user.reputation_total += score
        user.save
        #back to reputation
        reputation.total = user.reputation_total
        reputation.save
      end
    end
  end

  def self.get_score(objekt)
    case objekt
      when Recipe then 20
      when RecipeByOthers then 20
      when Blog then 20
      when Ingredient then objekt.revisable_number.to_i > 0 ? 5 : 10
      when Rating then
        case objekt.rating.to_i
          when 1 then -5
          when 2 then 0
          when 3 then 5
          when 4 then 15
          when 5 then 25
        end
    else
       if objekt.kind_of?(Achievement)
         objekt.level.to_i * 10
       end
    end
  end

  def self.get_reason(objekt)
    case objekt
      when Recipe then 'added a new Recipe'
      when RecipeByOthers then 'tried a recipe'
      when Blog then 'added a new Blog'
      when Ingredient then objekt.revisable_number.to_i > 0 ? 'edited an Ingredient' : 'added a new Ingredient'
      when Rating then
        case objekt.rating.to_i
          when 1 then 'received a 1 out of 5 rating'
          when 3..5 then "received a #{objekt.rating} out of 5 rating"
        end
    else
      if objekt.kind_of?(Achievement)
        "obtained a level #{objekt.level} Achievement"
      end
    end
  end

  def self.get_user_from_object(objekt)
    case objekt
      when Ingredient then objekt.revisable_number.to_i > 0 ? objekt.updated_by : objekt.user
      when Rating then objekt.rateable.user
    else
      objekt.user
    end
  end


end
