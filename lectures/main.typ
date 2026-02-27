#import "@preview/touying:0.6.0": *
#import themes.metropolis: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.6": *

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#set text(
  font: "Jost",
)

#show: metropolis-theme.with(
  config-colors(
    secondary: rgb("#D34516")
  ),
  aspect-ratio: "16-9",
  align: horizon,
  // config-common(handout: true),
  config-info(
    title: [Rust
    ],
    author: [Никита Рыданов],
    date: datetime.today(),
    institution: [факультет КНиИТ, СГУ],
    // logo: [&&], 
  ),
)

#show: codly-init.with()

#let config = (
  sh: (
    name: "Shell",
    strings: ("\"", "'")
  )
)
#show raw.where(lang: "sh"): block => [
  #local(
    number-format: none, lang-format: none, block)
]

#show figure: set align(center)

#show raw: set text(size: 0.9em)

#title-slide([Язык Rust])

#let input-codly(file, from, to, lang) = {
  let input = read(file)
  let splitted = input.split("\n")
  let slice = splitted.slice(from - 1, to)
  let result = slice.join("\n")
  raw(lang: lang, result, block: true)
}

#codly(languages: codly-languages, zebra-fill: none)

#include "chapters/intro.typ"
#include "chapters/basics.typ"
#include "chapters/borrow.typ"
#include "chapters/drop.typ"