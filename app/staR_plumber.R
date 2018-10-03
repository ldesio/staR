#setwd("M:/staR/rook/plumber")
.libPaths(Sys.getenv("R_LIBS_USER"))
winuser <- paste0("C:\\Users\\",Sys.getenv("USERNAME"),"\\AppData\\Local\\Pandoc\\pandoc.exe")

PDlocs <- c("pandoc", 
             "~/.cabal/bin/pandoc", 
             "~/Library/Haskell/bin/pandoc", 
             "C:\\PROGRA~1\\Pandoc\\bin\\pandoc\\pandoc.exe",
			 "C:\\Tools\\pandoc-2.3-windows-x86_64\\pandoc-2.3-windows-x86_64\\pandoc.exe",
			 winuser) 
             # Maybe a .exe is required for that last one?
             # Don't think so, but not a regular Windows user

activePDlocs <- Sys.which(PDlocs)
activePDloc <- activePDlocs[min(which(activePDlocs != ""))]	 
#cat("--- ",activePDloc,"---")

#Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")
Sys.setenv(RSTUDIO_PANDOC=dirname(activePDloc))


#cat("*** ",Sys.getenv("RSTUDIO_PANDOC"),"***")

source(file="_init.R")
svr <- plumber::plumb("api.R")
s <- svr$run(port=8000)
