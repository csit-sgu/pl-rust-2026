#let blue = rgb("#2b3fff")
#let red = rgb("#d62828")

#let check-mark-svg(color) = read("check-mark.svg").replace("#ffffff", color.to-hex())

#let check-mark(color, width: auto, height: auto) = image(bytes(check-mark-svg(color)), width: width, height: height)

#let check-list-icon(color) = place()[
  #curve(
    stroke: (paint: color, thickness: 3.0pt),
    fill: none,
    curve.move((-5pt, 2pt)),
    curve.line((15pt, 2pt)),
    curve.move((-5pt, 9pt)),
    curve.line((15pt, 9pt)),
    curve.move((-5pt, 16pt)),
    curve.line((15pt, 16pt)),
  )
  #place(dx: -13pt, dy: -18pt, check-mark(color, height: 40%))
  #place(dx: -13pt, dy: -11pt, check-mark(color, height: 40%))
  #place(dx: -12pt, dy: -2pt, circle(fill: color, radius: 2pt))
]

#let infobox(icon, color, body) = grid(
  columns: (15pt, 4pt, auto),
  rows: (auto, auto),
  column-gutter: 10pt,
  block(height: 18pt)[#icon],
  grid.cell(fill: color, block()),
  body,
)

#let awesome-block(body) = infobox(check-list-icon(blue), blue, body)
