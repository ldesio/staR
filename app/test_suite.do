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


