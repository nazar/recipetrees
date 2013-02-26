class ChartsController < ApplicationController

  def reputation
    user = User.find_by_id(params[:id].to_i) || not_found
    #data
    data = Line.new(2,'#80a033')
    data.key('Reputation', 10)
    #load reputation from user
    user.reputations.each do |reputation|
      data.add_data_tip(reputation.total, "#{reputation.reputation} points - #{reputation.reason}")
    end

    #now the graph
    g = Graph.new
    g.title("#{user.name} - Reputation History", "{font-size: 20px; color: #275f48}")
    g.data_sets << data
    g.set_tool_tip('Reputation: #val#<br>#tip#<br>on #x_label#')
    g.set_x_labels (user.reputations.collect{|rep| rep.created_at.strftime('%m/%d/%Y')} + [Time.now.strftime('%m/%d/%Y')]).flatten
    g.set_x_label_style(10, '#000000', 0, user.reputations.count(1) / 5)
    g.set_x_legend("Date", 16, "#275f48")

    g.set_y_max(user.reputation_total)
    g.set_y_label_steps(10)
    g.set_y_legend("Reputation", 16, "#275f48")

    render :text => g.render
  end

end
