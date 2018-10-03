# #* @assets ./html /
# list()

# #* @assets ./outfile_files /outfile_files
# list()

#* @assets . /
list()


#' @get /command
#' @html
function(command){
  star(command)
  fileName <- 'outfile.html'
  readChar(fileName, file.info(fileName)$size)
  # "<script> window.scrollTo(0,document.body.scrollHeight);</script>"
}


#' @get /cmdap
#' @html
function(command){
  star(command)
  cat(readChar("outfile.html", file.info("outfile.html")$size),file="main.html",append=TRUE)
  readChar("main.html", file.info("main.html")$size)
  # "<script> window.scrollTo(0,document.body.scrollHeight);</script>"
}

#' @get /init
#' @html
function(){
  star_header()
  fileName <- 'outfile.html'
  readChar(fileName, file.info(fileName)$size)
  # "<script> window.scrollTo(0,document.body.scrollHeight);</script>"
}

#' @get /vartable
#' @serializer unboxedJSON
function(){
  cbind(attributes(star.data)$names,attributes(star.data)$var.labels)
}

