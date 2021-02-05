# Admin # =======================================================================================================
rm(list=ls())

library(tidyverse)
library(magrittr)
library(stringr)

stardata <- haven::read_dta(url("http://cise.luiss.it/data/mini_wvs2005_spain.dta"))


# Section 1: Parsing the Command Line # =========================================================================

# Command line # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# Examples w/o 'generate'
# commandline <- "recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1)" # example 1
# commandline <- "recode sat_life (1/5 = 0) (6/10 = 1)" # example 2
# commandline <- "recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1)" # example 3

# Examples w 'generate'
# commandline <- "recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1), generate(sat_life_dummy)" # example 4
# commandline <- "recode sat_life (1/5 = 0) (6/10 = 1), generate(sat_life_dummy)" # example 5
commandline <- "recode sat_fin_fam (1/5 = 0) (6/10 = 1), generate(sat_fin_fam_dummy)" # example 6

# Examples w 'generate' but more than one var in varlist (=> Error)
# commandline <- "recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1), generate(sat_life_dummy)" # example 7


# Command # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Get the command
command <- 
  commandline %>%
  str_extract(pattern = "^[^ ]+")

# Variable(s) to be recoded # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# This string is created by removing the first word of the command line (+ blank space), namely the Stata command.
commandline_wo_command <- 
  commandline %>%
  gsub('\\b(recode)+\\s\\b', '', .) 

# Then, this string is created by getting everything before the first parenthesis. 
varlist <- 
  commandline_wo_command %>%
  str_extract("^([^(])+") %>%
  str_trim() %>%
  str_split(pattern = " ") %>% 
  unlist() %>% 
  as.list()

# Arguments of 'recode' # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# IF commandline has the comma THEN get the name of the new variable, otherwise NA
comma <- str_count(commandline_wo_command, ',')

if (comma == 1) {
  newvar <- 
    commandline_wo_command %>%
    str_extract("[^,\\s]*$") %>% # Extract any character after the first comma
    str_extract('\\(([^\\)]+)\\)') %>% # Extract the string between parentheses 
    gsub("[()]", "", .) %>%
    as.list()
} else {
  newvar <- NA # Assign 'NA' if there's no comma, namely no 'generate' argument
}


# Get the arguments of recode
arguments <- 
  commandline_wo_command %>%
  gsub("^([^(])+", "", .) %>% # Any character before the first parenthesis is removed 
  str_extract("^([^,])+") %>% # Any character before the first comma is extracted
  str_extract_all('\\(([^\\)]+)\\)') # This passage splits the arguments delimited by the parentheses


# This loop splits the arguments in two separate strings
arguments_lst <- c()
for(i in 1:length(arguments[[1]])) {
  arguments_lst[[i]] <- arguments[[1]][i]
}
arguments <- arguments_lst
rm(i, arguments_lst)

# This function removes the parentheses from each element of the list
arguments <- lapply(arguments, function(x) gsub("[()]", "", x))


# - - - # THIS IS THE POINT AT WHICH LABELS' DEFINITION CAN BE IMPLEMENTED # - - - #


# This function gets the values before '='
values <- 
  arguments %>%
  lapply(., function(x) str_extract(x, "^([^=])+")) %>%
  lapply(., function(x) str_trim(x))

# This function gets the values following '='
newvalues <- 
  arguments %>% 
  lapply(., function(x) str_extract(x, "[^=\\s]*$")) %>%
  lapply(., function(x) as.numeric(x))



# This function creates the numeric vectors of the varlist values
parsevalues_fun <- function(vals) {
  
  fctr <- str_count(vals, pattern = "/")
  
  if (fctr==0) {
    
    vals %<>% 
      str_split(" ") %>%
      lapply(., function(x) as.numeric(x)) %>%
      unlist()
    return(vals)
    
    
  } else if (fctr==1) {
    
    minval <- vals %>% str_extract("^([^/])+") %>% as.numeric()
    maxval <- vals %>% str_extract("[^/]*$") %>% as.numeric()  
    vals <- minval:maxval %>% as.numeric()
    return(vals)
    
  }  
  
}

values %<>% lapply(., parsevalues_fun)


# Section 2: Recoding Data # ====================================================================================


# Creating a dataframe for mapping the recoding - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
vls <- values %>% do.call("c",.)

nwvls <- c()
for(i in 1:length(newvalues)) {
  x <- rep(newvalues[[i]], length(values[[i]]))  
  nwvls <- c(nwvls, x)
  rm(x)
}
rm(i)

values_df <- data.frame(values = vls, newvalues = nwvls)
rm(vls, nwvls)


# Internal function to recode data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mutatefun <- function(vrbl) {
  for(i in 1:nrow(values_df)) {
    stardata[[vrbl]][stardata[[vrbl]]==values_df[i,1]] <- values_df[i,2]
  }
  return(stardata)
}



# Recoding data section based on conditional statements - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (length(varlist)!=0 & comma==0) { # If there's no comma(that is, no 'generate') 

  vrbls <- varlist %>% unlist()
  for(i in vrbls) {
    stardata[[i]] <- haven::zap_labels(stardata[[i]])
  }
  rm(vrbls, i)
  
  for(i in 1:length(varlist)) {
    stardata <- mutatefun(varlist[[i]])  
  }
  rm(i)  
  
} else if (length(varlist)==1 & comma==1) { # If there's a comma(that is, 'generate') and there's only one var

  stardata[[newvar[[1]]]] <- stardata[[varlist[[1]]]]
  
  for(i in 1:length(newvar)) {
    stardata <- mutatefun(newvar[[i]])  
    stardata[[newvar[[i]]]] %<>% as.numeric()
  }

} else {  # If there's a comma(that is, 'generate') and there are more than one var
  
  print("error")

}




