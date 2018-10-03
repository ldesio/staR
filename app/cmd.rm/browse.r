#syntax varlist

tmp <- capture.output(edit(star.data[cmd$varlist]))
pandoc.p("No output generated.")
