class DashboardsController < ApplicationController
  include ChartParamsService

  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    cs = ChartService.new(current_user)
    if current_user.journal_entries?
      cs.get_emotion_data_from_user(datetime_params[0], datetime_params[1])
    end
    @chart = cs.render_dashboard_plot

    if comparison_graph?
      cs2 = ChartService.new(current_user, {title: "#{emotion_names}",
      y_title: "",
      x_min: time_interval[:start],
      x_max: time_interval[:end]})

      cs2.get_emotion_data_from_user_for(emotion_params,
                                        interval_params[0] - 1.day,
                                        interval_params[1] + 1.day)

      emotion_prototype = emotion_params.first
      interval = params["emotions"]["days"].to_i


      sr = SelfReflection.new(current_user, interval, emotion_prototype)
      comparisons = sr.distances_between_current_interval_and_past_intervals


      comparisons << [1000,0]
      min = comparisons.min_by{|x| x[0]}
      start, fin = min[1] - 1.day, min[1] + interval.day + 1.day


        cs3 = ChartService.new(current_user, {title: "Time similar to current #{emotion_prototype.name}",
        y_title: "",
        x_min: start.to_i * 1000,
        x_max: fin.to_i * 1000})

      cs3.get_emotion_data_from_user_for(emotion_params,
                                        start,
                                        fin)

      @chart3 = cs3.render_dashboard_plot
      @chart2 = cs2.render_dashboard_plot
    end

    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def comparison_graph?
    !!params["emotions"] && params["emotions"]["days"].to_i > 0 && !emotion_params.empty? && current_user.has_journal_entries?
  end
end
