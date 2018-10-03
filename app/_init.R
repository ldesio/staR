#setwd("M:/staR/rook/plumber")

source(file="cmd.rm/_star_lib.R")

require(rmarkdown)
require("R2HTML")
require(pander)
require(stargazer)
require(plumber)
require(gtools)
require(lm.beta)
require(psych)

star_header <- function() {
  sink("outfile.R")
  cat("#' ---\r\n")
  cat("#' title: staR output\r\n")
  cat("#' output:\r\n")
  cat("#'   html_document:\r\n")
  cat("#'     self_contained: false\r\n")
  # cat("#'     code_folding: hide\r\n")
  cat("#'     df_print: kable\r\n")
  cat("#'     mathjax: FALSE\r\n")
  #  cat("#'     toc: true\r\n")
  #  cat("#'     toc_float: true\r\n")
  cat("#'     theme: united\r\n")
  cat("#'     highlight: tango\r\n")
  cat("#' ---\r\n\r\n")
  
  cat ("\r\n\r\n#+ results='asis', echo=FALSE\r\n")
  cat("knitr::include_graphics('./logo_splash_medium.png')\r\n\r\n\r\n")
  
  #cat("```{r echo=FALSE, out.width='100%'}")
  #cat("knitr::include_graphics('./logo_splash_medium.png')")
  #cat("```")
  
  sink()
  render(input = "outfile.R")
}

star <- function(cmdline) {
  
  sink("outfile.R")
  
  fragment <- TRUE;
  
  if (!fragment) {
    cat("#' ---\r\n")
    cat("#' title: staR output\r\n")
    cat("#' output:\r\n")
    cat("#'   html_document:\r\n")
    cat("#'     self_contained: true\r\n")
    cat("#'     code_folding: hide\r\n")
    cat("#'     df_print: kable\r\n")
    cat("#'     mathjax: FALSE\r\n")
    #  cat("#'     toc: true\r\n")
    #  cat("#'     toc_float: true\r\n")
    cat("#'     theme: united\r\n")
    cat("#'     highlight: tango\r\n")
    cat("#' ---\r\n\r\n")
  } else {
    cat("#' ---\r\n")
    cat("#' title: staR output\r\n")
    cat("#' output:\r\n")
    cat("#'   html_fragment:\r\n")
    cat("#'     self_contained: true\r\n")
    cat("#'     lib_dir: libs\r\n")
    #     #  cat("#'     code_folding: hide\r\n")
    cat("#'     df_print: kable\r\n")
    cat("#'     mathjax: FALSE\r\n")
    #     
    #     #  cat("#'     toc: true\r\n")
    #     #  cat("#'     toc_float: true\r\n")
   # cat("#'     theme: united\r\n")
   #cat("#'     highlight: tango\r\n")
    cat("#' ---\r\n\r\n")
  }
  
  
  cat("\r\n\r\n#' <div class='panel panel-primary'><div class='panel-heading'>")
  cat(paste("<h3 class='panel-title'>",cmdline,"</h3></div>"))
  cat("<div class='panel-body'>")
  
  cat ("\r\n#+ results='asis', echo=FALSE\r\n")
  cat("source(file=\"cmd.rm/_star_lib.R\")\r\n")
  cat(paste("star.cmdline <- \"", trimws(cmdline), "\"",sep=""))
  star.cmdline <<- trimws(cmdline)
  
  
  
  
  # cat ("\r\n\r\n#+ results='asis', echo=FALSE\r\n")
  syntax <- gsub("echo=TRUE","echo=FALSE",star.source(star.cmdline))
  
  # should check here that required variables exist... (cmd$varlist ?)
  # cat(cmd)
  
  
  tryCatch({ 
    
    # command exists 
    if (syntax!=star.cmdline) {
      cat(syntax)
    } else {
      pos_firstspace <- regexpr (' ',star.cmdline)
      command <- substring(star.cmdline,1,pos_firstspace-1)
      cat(paste("\r\n\r\n#' ", errorPanel.return(paste0("*",command,"* is not an available command.<br>If it's a Stata command, it means it has not yet been implemented in staR.<br/>You can implement it by writing the appropriate ",command,".R file in the 'cmd.rm' directory."))))
    }
    
    cat("\r\n\r\n#' </div></div>")
    
    sink()
    
    
    
    
    render(input = "outfile.R")
  }, error = function(err) {
    sink("outfile.html")
    #cat("\r\n\r\n<div class='alert alert-danger'><h4>Error!</h4>")
    #cat(paste("<p>",err,"</p></div>"))
    
    cat(paste("\r\n\r\n", errorPanel.return(err)))
    
    
    sink();
    # render(input = "outfile.R")
  }, warning = function(err) {warningPanel(err)}
  )
  
  
  
  
  
}