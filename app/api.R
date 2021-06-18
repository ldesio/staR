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

