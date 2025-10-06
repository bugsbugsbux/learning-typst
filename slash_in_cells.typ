// vim: spelllang=en


// Produces a table cell (width 1em) with a diagonal line from bottom
// left to top right.
#let _slash() = {
  // this is the slash
  let content = context {
    box(width: 1em)
    place(top + left,
      line(
        start: (0%, 100%),
        end: (100%, 0%),
        stroke: 0.5pt,
      ),
    )
  }
  table.cell(
    content,
    inset: 0pt,
    breakable: false,
    stroke: (left: 0pt, right: 0pt),
  )
}

// Usage example: Formatting accouting events.

// Helper to format a single accouting event using a single line table.
// The two sides are separated with the _slash() function from above
// when multi:true and a regular slash character otherwise since this
// looks better when only two accounts are involved.
#let bs(soll, haben, multi: false) = table(
  columns: 3,
  stroke: 0pt,
  //stroke: silver,
  align: horizon,
  [#soll],
  if multi == true {
    _slash()
  } else {
    table.cell(
      stroke: (left: 0pt, right: 0pt),
      inset: 0pt,
    )[*\/*]
  },
  [#haben],
)
// alias to not have to explicitly use the multi:true option
#let mbs = bs.with(multi: true)

// Formats *one side* such that its accounts' names are aligned and
// their respective amounts are right-aligned.
//
// Takes account names (with prepended ids) and respective amounts
// alternately. Decimal point and places as well as thousands separators
// have to be entered manually and should be uniform!
//
#let konten = grid.with(
  columns: 2,
  align: (left, right),
  row-gutter: 0.7em,
  column-gutter: 0.5em,
)

// single account per side
#bs[ 0 PKW ][ 2 Bank 22.000 ]

// multiple accounts on a single side is accomplished with manual
// linebreaks...
#mbs[
  0 LKW 100.000 \
  2 VSt 20.000 \
][
  2 Bank 120.000
]

// ... or with the helper `konten()` which also aligns names and amounts
#mbs[ 6 Gehälter 75.000,00 ][
  #konten(
    "3 Verb ÖGK", "13.590,00",
    "3 Verb FA", "7.702,50",
    "3 Verb MA", "53.707,50",
  )
]
