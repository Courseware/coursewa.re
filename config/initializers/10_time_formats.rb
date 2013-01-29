Time::DATE_FORMATS[:month_and_year] = '%B %Y'
Time::DATE_FORMATS[:pretty_date] = '%a, %b %e'
Time::DATE_FORMATS[:pretty_time] = '%H:%M'
Time::DATE_FORMATS[:pretty_date_and_year] = '%a, %b %e, %Y'
Time::DATE_FORMATS[:pretty] = lambda { |time|
  _('%s at %s') % [time.strftime('%a, %b %e'), time.strftime('%H:%M')]
}
