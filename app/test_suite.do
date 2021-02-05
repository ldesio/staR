use http://cise.luiss.it/data/mini_wvs2005_spain.dta 
tab1 woman
tab1 woman edu8 socclass_subj5
tab2 edu8 woman
tab2 edu8 woman, row
tab2 edu8 woman, col
tab2 edu8 woman, row col
tab2 edu8 woman, row col nofreq

hist woman
// DOESN'T WORK ONLINE (Linux, R latest version) BUT WORKS LOCALLY (Windows, perhaps older version)!!!
hist edu8 
hist age
by woman: hist edu8

summarize woman age agesq edu8 socclass_subj5 income

browse

regress sat_life woman age agesq i.edu8
regress sat_life woman age agesq i.edu8#income
regress sat_life woman age agesq i.edu8##income
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom, beta
regress sat_life woman age agesq edu8 socclass_subj5 income health_subj trustpeople feelfreedom imp_family imp_friends imp_leisure imp_politics imp_work imp_religion
regress sat_life woman##imp_work
regress sat_life woman#imp_work

logit woman age sat_life agesq

scatter edu8 age
scatter age agesq

generate agesq2 = age^2
hist agesq2

// Recode test
* Values labeling does not work
recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1) // one var, noslash, nolabel, nogen [WORKS]
recode sat_life (1/5 = 0) (6/10 = 1) // one var, slash, nolabel, nogen [WORKS]
recode sat_life sat_fin_fam (1 2 3 4 5 = 0) (6 7 8 9 10 = 1) // two vars, noslash, nolabel, nogen [WORKS]
recode sat_life sat_fin_fam (1/5 = 0) (6/10 = 1) // two vars, slash, nolabel, nogen [WORKS]
recode sat_life (1 2 3 4 5 = 0) (6 7 8 9 10 = 1), generate(sat_life2) // one var, noslash, nolabel, gen [WORKS]
recode sat_life (1/5 = 0) (6/10 = 1), generate(sat_life2) // one var, slash, nolabel, gen [WORKS]

// label var test
lab var age "Age of respondents" [WORKS]

lab val age "Age of respondents" [should reproduce an error]
lab dir [should reproduce an error]
lab l age "Age of respondents" [should reproduce an error]
lab data [should reproduce an error]


