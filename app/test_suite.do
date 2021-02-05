// Test suite
* Last update: 2021-01-22

use http://cise.luiss.it/data/mini_wvs2005_spain.dta 

// tab1 examples
tab1 woman
tab1 woman edu8 socclass_subj5

// tab2 examples
tab2 edu8 woman
tab2 edu8 woman, row
tab2 edu8 woman, col
tab2 edu8 woman, row col
tab2 edu8 woman, row col nofreq

// hist examples 
// DOESN'T WORK ONLINE (Linux, R latest version) BUT WORKS LOCALLY (Windows, perhaps older version)!!!
hist woman
hist edu8 
hist age
by woman: hist edu8

// scatter examples
scatter edu8 age
scatter age agesq

// summarize examples
summarize woman age agesq edu8 socclass_subj5 income

// browse examples 
browse

// recode examples
// Values labeling still does not work.
* recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1) 
* recode sat_life (1/5 = 0) (6/10 = 1) 
* recode sat_life sat_fin_fam (1 2 3 4 5 = 0) (6 7 8 9 10 = 1) 
* recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1) 
recode sat_life (1/5 = 0) (6/10 = 1), generate(sat_life_dummy) 
recode sat_fin_fam (1/5 = 0) (6/10 = 1), generate(sat_fin_fam_dummy) 

// generate & replace examples
generate agesq2 = age^2
generate logage = age
replace logage = log(logage)

// drop & keep examples
drop logage
keep sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom imp_family imp_friends imp_leisure imp_politics imp_work imp_religion
drop if age<20 & age>80
keep if age>19 & age<81

// regress examples
// All the examples can be replicated using the 'beta' option
regress sat_life woman age agesq i.edu8
regress sat_life woman age agesq i.edu8#income
regress sat_life woman age agesq i.edu8##income
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom, beta
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom imp_family imp_friends imp_leisure imp_politics imp_work imp_religion
regress sat_life woman##imp_work
regress sat_life woman#imp_work
regress sat_life woman#imp_work

// logit examples
logit sat_life_dummy woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom
logit sat_life_dummy woman age agesq i.edu8##income
logit sat_fin_fam_dummy woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom imp_work imp_leisure

// label variable examples
* label copy/data/define/dir/drop/language/list/values should reproduce an error
lab var age "Age of Respondents" 
lab var agesq "Age of Respondents (squared)" 


