Time::DATE_FORMATS[:month_and_year] = '%B %Y'
Time::DATE_FORMATS[:pretty] = lambda { |time|
  _('%s at %s') % [time.strftime('%a, %b %e'), time.strftime('%H:%M')]
}
