# Admin # =======================================================================================================
want = c("tidyverse", "magrittr", "stringr", "labelled")
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
junk = lapply(want, library, character.only = TRUE)
rm(list=ls())

stardata <- haven::read_dta(url("http://cise.luiss.it/data/mini_wvs2005_spain.dta"))


# Section 1: Parsing the Command Line # =========================================================================

# Command line # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

### Examples w/o 'generate'
# commandline <- "recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1)" # example 1
# commandline <- "recode sat_life (1/5 = 0) (6/10 = 1)" # example 2
commandline <- "recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1)" # example 3

### Examples w 'generate'
# commandline <- "recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1), generate(sat_life_dummy)" # example 4
# commandline <- "recode sat_life (1/5 = 0) (6/10 = 1), generate(sat_life_dummy)" # example 5
# commandline <- "recode sat_fin_fam (1/5 = 0) (6/10 = 1), generate(sat_fin_fam_dummy)" # example 6
# commandline <- 'recode sat_fin_fam (1/5 = 0 "dissat") (6/10 = 1 "sat"), generate(sat_fin_fam_dummy)' # example 7

### Examples w 'generate' but more than one var in varlist (=> Error) or with labels but w/o 'generate' (=> Error)
# commandline <- "recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1), generate(sat_life_dummy)" # example 8
# commandline <- 'recode sat_fin_fam (1/5 = 0 "dissat") (6/10 = 1 "sat")' # example 9


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
if (str_detect(commandline_wo_command, ',')) {
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


# This block creates a list of labels, but returns an error in the case in which labels are defined w/o "generate" 

thereiscomma <- str_detect(commandline_wo_command, ',')
thereisquote <- str_detect(commandline_wo_command, '\"') 
lbls <- list()

if (thereiscomma==T & thereisquote==T) {
  for(i in 1:length(arguments)) {
    lbls[[i]] <- str_extract(arguments[[i]], '"([^"]*)"') %>%
      gsub("\"", "", .)
    arguments[[i]] <- arguments[[i]] %>% str_extract("^([^\"])+") %>% str_trim()
  } 
} else if (thereiscomma==T & thereisquote==F) {
  for(i in 1:length(arguments)){
    lbls[[i]] <- NA_character_    
  } 

} else if (thereiscomma==F & thereisquote==T) {
  print("Cannot define labels without generating a new variable")
} else if (thereiscomma==F & thereisquote==F) {
  for(i in 1:length(arguments)) {
    lbls[[i]] <- NA_character_    
  } 
}


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
  
  if (str_detect(vals, pattern = "/")==F) {
    
    vals %<>% 
      str_split(" ") %>%
      lapply(., function(x) as.numeric(x)) %>%
      unlist()
    return(vals)
    
    
  } else if (str_detect(vals, pattern = "/")==T) {
    
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
nwlbls <- c()
for(i in 1:length(newvalues)) {
  x <- rep(newvalues[[i]], length(values[[i]]))  
  y <- rep(lbls[[i]], length(values[[i]]))  
  nwvls <- c(nwvls, x)
  nwlbls <- c(nwlbls, y)
  rm(x, y)
}
rm(i)

values_df <- data.frame(values = vls, newvalues = nwvls, labels = nwlbls)
rm(vls, nwvls, nwlbls)


# Internal function to recode data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mutatefun <- function(vrbl) {
  for(i in 1:nrow(values_df)) {
    stardata[[vrbl]][stardata[[vrbl]]==values_df[i,1]] <- values_df[i,2]
  }
  return(stardata)
}



# Recoding data section based on conditional statements - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (length(varlist)>=1 & thereiscomma==F) { # If there's no comma(that is, no 'generate') 

  vrbls <- varlist %>% unlist()
  for(i in vrbls) {
    stardata[[i]] <- haven::zap_labels(stardata[[i]])
  }
  rm(vrbls, i)
  
  for(i in 1:length(varlist)) {
    stardata <- mutatefun(varlist[[i]])  
  }
  rm(i)  
  
} else if (length(varlist)==1 & thereiscomma==T) { # If there's a comma(that is, 'generate') and there's only one var

  stardata[[newvar[[1]]]] <- stardata[[varlist[[1]]]]
  
  for(i in 1:length(newvar)) {
    stardata <- mutatefun(newvar[[i]])  
    stardata[[newvar[[i]]]] %<>% as.numeric()
  }

} else {  # If there's a comma(that is, 'generate') and there are more than one var
  
  print("error")

}



# Section 3: Labeling # =========================================================================================

values_df %<>% 
  dplyr::select(-c(values)) %>% 
  distinct()

values_df$labels %<>% as.factor()

newvar %<>% unlist()

varlist %<>% unlist()

if (is.na(newvar)) {
  
  for(v in varlist) {
    for(i in 1:nrow(values_df)) {
      val_label(stardata[[v]], values_df[[i,1]]) <- values_df[[i,2]]
    }
  }
  
} else {
  
  for(i in 1:nrow(values_df)) {
    val_label(stardata[[newvar]], values_df[[i,1]]) <- values_df[[i,2]]
  }
}
