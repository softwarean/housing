module SegmentsConcern
  private

  def period_from_segment
    segment = params[:segment]
    date = DateTime.current

    if segment.nil? || segment == ::Constants::CURRENT_DAY_SEGMENT
      date.beginning_of_day..date.end_of_day
    elsif segment == ::Constants::YEAR_SEGMENT
      date.beginning_of_year..date.end_of_year
    else
      month = segment.to_i

      raise ArgumentError if month <= 0

      date -= 1.month until date.month == month

      date.beginning_of_month..date.end_of_month
    end
  end
end
