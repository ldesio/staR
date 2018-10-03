#required on Windows
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
.libPaths(Sys.getenv("R_LIBS_USER"))

install.packages("rmarkdown", repos='http://cran.us.r-project.org')
install.packages("R2HTML", repos='http://cran.us.r-project.org')
install.packages("pander", repos='http://cran.us.r-project.org')
install.packages("stargazer", repos='http://cran.us.r-project.org')
install.packages("plumber", repos='http://cran.us.r-project.org')
install.packages("gmodels", repos='http://cran.us.r-project.org')
install.packages("lm.beta", repos='http://cran.us.r-project.org')
install.packages("psych", repos='http://cran.us.r-project.org')
install.packages("later", repos='http://cran.us.r-project.org')

