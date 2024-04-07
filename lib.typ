#import "nord.typ": *
#import "date.typ": *

#let karenda(year: datetime.today().year(), begin-weekday: 1, body) = {
  let dates-by-month-week = get-dates(year, begin-weekday)
   
  let left-margin = 15pt
  let left-margin-content = 60pt
   
  let top-margin = 20pt
  let top-margin-content = 50pt
   
  let radius = 5pt
  let inner-inset = (x: 6pt, y: 5pt)
  let outer-inset = (x: 4pt, y: 5pt)
   
  let font-size = 12pt
   
  let text-color = nord0
  let text-color-light = nord4
  let stroke-color = nord8
  let panel-background-color = nord5
  let panel-background-color-active = nord4
   
  let month-calender-week-num-column-width = font-size * 2
  let month-calender-column-width = 70pt
  let month-calender-weekday-column-height = font-size * 2
  let month-calender-day-num-row-height = 15pt
  let month-calender-text-field-row-height = 45pt
   
  let month-calender-columns = (month-calender-week-num-column-width,) + (month-calender-column-width,) * 7
  let month-calender-rows = n => (month-calender-weekday-column-height,) + (
    month-calender-day-num-row-height,
    month-calender-text-field-row-height,
  ) * n
   
  let month-calender-width = month-calender-week-num-column-width + month-calender-column-width * 7
  let notes-left-margin = month-calender-width + left-margin-content + 20pt
  let notes-top-margin = top-margin-content + 10pt
  let notes-width = 230pt
  let monthly-goals-height = 150pt
  let notes-height = 150pt
   
  let stroke = (thickness: 1pt, paint: stroke-color)
  let text-field-pattern = pattern(size: (10pt, 10pt))[
    #place(line(start: (0%, 0%), end: (0%, 100%), stroke: stroke))
    #place(line(start: (0%, 0%), end: (100%, 0%), stroke: stroke))
  ]
   
  let place-label(l) = {
    place(left + top, [\ #label(l)])
  }
   
  let place-big-year(year) = {
    place(left + top, dx: left-margin, dy: top-margin, {
      text([#year], fill: text-color, size: font-size * 2)
    })
  }
   
  let month-panel-button(month, fill) = link(label(month-short-text.at(month)), box(
    fill: fill,
    inset: inner-inset,
    radius: radius,
    { month-short-text.at(month) },
  ))
   
  let place-month-panel(highlight-month) = {
    place(
      left + horizon,
      dx: left-margin,
      {
        block(fill: panel-background-color, inset: outer-inset, radius: radius, {
          set align(center)
          for month in range(12) {
            if month == highlight-month {
              month-panel-button(month, panel-background-color-active)
            } else {
              month-panel-button(month, none)
            }
            linebreak()
          }
        })
      },
    )
  }
   
  let place-big-month(month) = {
    place(left + top, dx: left-margin-content, dy: top-margin, {
      text(
        [#h(font-size * 2) #month-long-text.at(month)],
        fill: text-color,
        size: font-size * 2,
      )
    })
  }
   
  let month-calender-header = table.header(..(([],) + (weekday-names * 2).slice(begin-weekday - 1, count: 7)))
   
  let month-calender(num-weeks, data) = {
    return table(
      columns: month-calender-columns,
      rows: month-calender-rows(num-weeks),
      align: (x, y) => {
        if x == 0 or y == 0 or calc.rem(y, 2) == 1 {
          center + horizon
        } else {
          left + top
        }
      },
      stroke: (x, y) => {
        if y > 0 {
          (right: stroke)
        }
        if x > 0 and calc.rem(y, 2) == 0 {
          (bottom: stroke)
        }
      },
      month-calender-header,
      ..data,
    )
  }
   
  let place-notes = {
    place(left + top, dx: notes-left-margin, dy: notes-top-margin, {
      text([Monthly Goals], fill: text-color, size: font-size * 1.2)
      v(-.5em)
      rect(
        fill: text-field-pattern,
        width: notes-width,
        height: monthly-goals-height,
        stroke: 1pt + text-color-light,
      )
      text([Notes], fill: text-color, size: font-size * 1.2)
      v(-.5em)
      rect(
        fill: text-field-pattern,
        width: notes-width,
        height: notes-height,
        stroke: 1pt + text-color-light,
      )
    })
  }
   
  let get-month-calender(month, dates-by-week) = {
    let result = ()
    for (i, week) in dates-by-week {
      result.push(table.cell(rowspan: 2, [#(i + 1)]))
      for day in week {
        result.push(table.cell({
          if day.month() - 1 == month {
            text(fill: text-color)[#day.day()]
          } else {
            text(fill: text-color-light)[#day.day()]
          }
        }))
      }
      for _ in week {
        result.push[]
      }
    }
    return result
  }
   
  let month-pages = {
    for month in range(12) {
      let dates-by-week = dates-by-month-week.at(month)
      let data = get-month-calender(month, dates-by-week)
       
      set page(background: {
        place-label(month-short-text.at(month))
        place-big-year(year)
        place-month-panel(month)
        place-big-month(month)
        place-notes
      })
       
      month-calender(dates-by-week.len(), data)
      pagebreak(weak: true)
    }
  }
   
  set page(
    paper: "presentation-16-9",
    margin: (left: left-margin-content, top: top-margin-content, bottom: 0pt),
    fill: nord6,
  )
   
  set text(font: "Libre Baskerville", size: font-size, fill: text-color)
   
  month-pages
}