create or replace function f_days_from_holiday (year SMALLINT, month SMALLINT, day SMALLINT)
returns int
stable
as $$
  import datetime
  from datetime import date
  import dateutil
  from dateutil.relativedelta import relativedelta

  fdate = date(year, month, day)

  fmt = '%Y-%m-%d'
  """set state date to 7 days before current date"""
  s_date = fdate - dateutil.relativedelta.relativedelta(days=7)
  """set end date to 1 month after current date"""
  e_date = fdate + relativedelta(months=1)

  start_date = s_date.strftime(fmt)
  end_date = e_date.strftime(fmt)

  """
  Compute a list of holidays over a period (7 days before, 1 month after) for the flight date
  """
  from pandas.tseries.holiday import USFederalHolidayCalendar
  calendar = USFederalHolidayCalendar()
  holidays = calendar.holidays(start_date, end_date)
  
  days = None
  
  if len(holidays) > 0:
  	days_from_closest_holiday = [(abs(fdate - hdate)).days for hdate in holidays.date.tolist()]
  	days = min(days_from_closest_holiday)
  
  return days
$$ language plpythonu;