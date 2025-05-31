defmodule TourinIt.DateAndTimeHelpers do
  def format_date(date), do: Calendar.strftime(date, "%B %d, %Y")
  def day_of_the_week(date), do: Calendar.strftime(date, "%a")
end
