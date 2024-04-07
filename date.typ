#import "nord.typ": *

#let weekday-names = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
#let month-first-days = range(1, 13).map(month => datetime(year: 2024, month: month, day: 1))
#let month-short-text = month-first-days.map(date => date.display("[month repr:short]"))
#let month-long-text = month-first-days.map(date => date.display("[month repr:long]"))

#let get-dates(year, begin-weekday) = {
  let first-day = datetime(year: year, month: 1, day: 1)
  let next-weekday = calc.rem(begin-weekday - 1, 7) + 1
   
  let dates-by-week = ()
  let dates-by-week-temp = ()
   
  let current-date = first-day - duration(days: first-day.weekday() - calc.rem(begin-weekday, 7))
  while current-date.year() <= year or current-date.weekday() != next-weekday {
    if current-date.weekday() == next-weekday and dates-by-week-temp.len() > 0 {
      dates-by-week.push(dates-by-week-temp)
      dates-by-week-temp = ()
    }
    dates-by-week-temp.push(current-date)
    current-date = current-date + duration(days: 1)
  }
   
  if dates-by-week.len() > 0 {
    dates-by-week.push(dates-by-week-temp)
  }
   
  let dates-by-month-week = ()
  let dates-by-month-week-temp = ()
  let month = 1
  for i in range(dates-by-week.len()) {
    let week = dates-by-week.at(i)
    let begin-month = week.at(0).month()
    let end-month = week.at(-1).month()
    if month == begin-month or month == end-month {
      dates-by-month-week-temp.push((i, week))
    }
    if month != end-month {
      dates-by-month-week.push(dates-by-month-week-temp)
      dates-by-month-week-temp = ((i, week),)
      month = end-month
    }
  }
  if dates-by-month-week-temp.len() > 0 {
    dates-by-month-week.push(dates-by-month-week-temp)
  }
   
  return dates-by-month-week
}