#' ---
#' title: staR output
#' output:
#'   html_fragment:
#'     self_contained: true
#'     lib_dir: libs
#'     df_print: kable
#'     mathjax: FALSE
#' ---



#' <div class='panel panel-primary'><div class='panel-heading'><h3 class='panel-title'> update test </h3></div><div class='panel-body'>
#+ results='asis', echo=FALSE
source(file="cmd.rm/_star_lib.R")
star.cmdline <- "update test"
cmd <- star_parse_stata_command("anything")
#syntax anything

enforce_packages(c("RCurl"))
library(RCurl)
pandoc.p("Update.")

#' </div></div>