#import "@preview/gentle-clues:1.2.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let setup_conf(doc) = {
  show: codly-init.with()
  codly(languages: codly-languages, number-format: none, zebra-fill: none)

  set page(margin: (top: 1.5cm, bottom: 1.5cm, left: 1.5cm, right: 1.5cm))

  set text(font: "Avenir Next")
  show raw: set text(font: "Geist Mono", size: 11pt)

  set heading(numbering: "1.1")
  show link: set text(fill: blue)
  doc
}

#let num = counter("num");
#let task_numbering() = { num.step(); num.display() };
