#* @assets ./static/ /star
list()

#* @assets ./static/ /
list()

#* Process Command and return JSON of output file
#* @get /cmdsink
#* @post /cmdsink
function(command) {
  
  library(evaluate)
  result <- evaluate(command)
  toJSON(result, force = TRUE)
}


# NOW USES /mutatedata
# #* Load data return JSON
# #* @get /loaddata
# #* @post /loaddata
#function(command) {
#  stardata <- eval(parse(text=command))
#  uniqueID <- as.numeric(Sys.time())*1000;
#  fileName <- paste0(uniqueID,".Rdata");
#  toJSON(list(stardata,attributes(stardata), fileName), force = TRUE)
#}

#* Load/Mutate data, return JSON
#* @get /mutatedata
#* @post /mutatedata
function(command, postprocess="") {
  stardata <- eval(parse(text=command))
  if (postprocess!="") eval(parse(text=postprocess))
  uniqueID <- as.numeric(Sys.time())*1000;
  fileName <- paste0(uniqueID,".Rdata");
  
  #save(stardata,file=fileName);
  #pre-Haven
  #toJSON(list(stardata,attributes(stardata), fileName), force = TRUE)
  
  # Haven version
  toJSON(list(stardata, 
            lapply(stardata,attr,which="label"),lapply(stardata,attr,which="format.stata"), lapply(stardata,attr,which="labels"),
              fileName), force = TRUE)
}



#* Process Command and return PNG URL in JSON
#* @get /cmdoutputPNGURL
#* @post /cmdoutputPNGURL
#function(command) {
#  tmp_filename <- paste0(format(Sys.time(), format = '%Y-%j-%H%M%S'),'.png')
#  png(paste0('static/',tmp_filename))
#  eval(parse(text=command))
#  dev.off()
#  imgtag <- paste0('<img src=',tmp,'>')
#  toJSON(imgtag, force = TRUE)
#}

#* Process Command and return PNG URL in JSON
#* @get /pngwithdata
#* @post /pngwithdata
#function(data, command) {
#  tmp_filename <- paste0(format(as.numeric(Sys.time())*1000,digits=15),'.png');
#  
#  eval(parse(text=data))
#  png(paste0('static/generated/',tmp_filename))
#  eval(parse(text=command))
#  dev.off()
#  imgtag <- paste0('<img src=generated/',tmp_filename,'>')
#  toJSON(imgtag, force = TRUE)
#}
