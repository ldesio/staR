install.packages("rmarkdown")
install.packages("R2HTML")
install.packages("pander")
install.packages("stargazer")

setwd("M:/staR/_ws/staR/")

source(file="cmd.rm/_star_lib.R")

library(rmarkdown)
library("R2HTML")
library(pander)
library(stargazer)

star_header <- function() {
  sink("outfile.R")
  cat("#' ---\r\n")
  cat("#' title: staR output\r\n")
  cat("#' output:\r\n")
  cat("#'   html_document:\r\n")
  cat("#'     code_folding: hide\r\n")
  cat("#'     df_print: kable\r\n")
  cat("#'     mathjax: FALSE\r\n")
  #  cat("#'     toc: true\r\n")
  #  cat("#'     toc_float: true\r\n")
  cat("#'     theme: united\r\n")
  cat("#'     highlight: tango\r\n")
  cat("#' ---\r\n\r\n")
  sink()
  render(input = "outfile.R")
}

star <- function(cmdline) {

  sink("outfile.R")
  
  cat("#' ---\r\n")
  cat("#' title: staR output\r\n")
  cat("#' output:\r\n")
  cat("#'   html_document:\r\n")
  cat("#'     self_contained: false\r\n")
  cat("#'     code_folding: hide\r\n")
  cat("#'     df_print: kable\r\n")
  cat("#'     mathjax: FALSE\r\n")
  #  cat("#'     toc: true\r\n")
  #  cat("#'     toc_float: true\r\n")
  cat("#'     theme: united\r\n")
  cat("#'     highlight: tango\r\n")
  cat("#' ---\r\n\r\n")
  
#     cat("#' ---\r\n")
#     cat("#' title: staR output\r\n")
#     cat("#' output:\r\n")
#     cat("#'   html_fragment:\r\n")
#     cat("#'     lib_dir: libs\r\n")
#     #  cat("#'     code_folding: hide\r\n")
#     cat("#'     df_print: kable\r\n")
#     cat("#'     mathjax: FALSE\r\n")
#     
#     #  cat("#'     toc: true\r\n")
#     #  cat("#'     toc_float: true\r\n")
#     #  cat("#'     theme: united\r\n")
#     #  cat("#'     highlight: tango\r\n")
#     cat("#' ---\r\n\r\n")

  
  
  cat("\r\n\r\n#' <div class='panel panel-primary'><div class='panel-heading'>")
  cat(paste("<h3 class='panel-title'>",cmdline,"</h3></div>"))
  cat("<div class='panel-body'>\r\n\r\n")

  cat ("\r\n\r\n#+ results='asis', echo=FALSE\r\n")
  cat("source(file=\"cmd.rm/_star_lib.R\")\r\n")
  cat(paste("star.cmdline <- \"", trimws(cmdline), "\"",sep=""))
  star.cmdline <<- trimws(cmdline)
  

  cat ("\r\n\r\n#+ results='asis', echo=TRUE\r\n")
  cat(star.source(star.cmdline))

  cat("\r\n\r\n#' </div></div>")

  sink()
  

  render(input = "outfile.R")
  
  
}

star("use docs/individualism.dta")
star("regress enjoy_*, beta")
# star("tab1 sex")
# star("regress enjoy_* yearbirth, beta")


#TODO:
#  test generic function for output?...
#FUTURE:
# declare signatures in separate file (taken from Stata):
#    automated checking of accurate syntax (es. check varlists and options [incl. required options])  
# must find some method for automating even the diagnostics of unimplemented options