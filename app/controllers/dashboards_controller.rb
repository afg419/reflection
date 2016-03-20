class DashboardsController < ApplicationController
  def show
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

  def index
    @chart = ocs.render_overall_chart
    # @chart = overall_chart_service.populate_overall_chart
    @chart2, @chart3 = comparison_chart_service.populate_comparison_charts
    if chart_fail?
      flash.now[:comparison_error] = comparison_chart_service.graph_fail_reasons
    end
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

private

  def ocs
    @ocs ||= OverallChartService.new(current_user,dates_for_overall_chart)
  end

  def cps
    @cps ||= ChartParamsService.new(current_user, params)
  end

  def overall_chart_service
    @cs ||= ChartService.new(current_user, {}, dates_for_overall_chart)
  end

  def comparison_chart_service
    @ccs ||= ComparisonChartService.new(current_user,
                                        cps.interval_params,
                                        cps.emotion_params)
  end

  def chart_fail?
    @chart3.nil? && params[:emotions]
  end

  def dates_for_overall_chart
    cps.datetime_params
  end
end
