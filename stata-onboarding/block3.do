* block3.do - cleaning the 1980 Census state data
* saves first_looks_clean.dta



* the data. a bare filename works because you are in the right folder

use "first_looks.dta", clear

* The asterisk tells Stata this line is a comment, not a command
// two slashes do the same, but can follow a command (notice which variables)
desc state // pop
/*
This above and below slash + asterisk combo makes a multi-line comment
*/

*** 3.3 Does the Data Add Up?

* add the four age groups together and call it check_pop
generate check_pop = poplt5 + pop5_17 + pop18p + pop65p

* compare it against pop
summarize pop check_pop

* notice how the numbers are different? Why?

* this one fails on purpose and stops the file. read the error
assert pop == check_pop

* work out which two age groups overlap before you run anything below

* the variable exists already, so this is replace, not generate
replace check_pop = poplt5 + pop5_17 + pop18p

* check it again. silence means it passed
summarize pop check_pop
assert pop == check_pop

* the same check from the other side
generate pop18_65 = pop18p - pop65p

* that name is wrong. the group runs 18 to 64
rename pop18_65 pop18_64

* build it from the groups that no longer overlap, and check
generate check2_pop = poplt5 + pop5_17 + pop18_64 + pop65p
summarize pop check2_pop
assert pop == check2_pop

* tidy up. the check variables have done their job
drop check_pop check2_pop


*** 3.4 ADVANCED - not for today. Functions.

* Stata does arithmetic, and ships a library of functions
generate pop_m = pop / 1000000
replace pop_m = round(pop_m, .1)

* nobody memorises the list. knowing it exists is the skill
help functions


*** 3.5 ADVANCED - not for today. Stored results.

* detail adds the percentiles
summarize pop, detail

* everything summarize just worked out is still sitting in memory
return list

* r(p90) is the 90th percentile. use it now or the next command wipes it
generate big_state = (pop >= r(p90))
list state pop if big_state == 1

* egen gets to the same answer by a different route
egen big_state2 = pctile(pop), p(90)
replace big_state2 = pop >= big_state2
assert big_state == big_state2
drop big_state2


*** 3.6 ADVANCED - not for today. Text.

* preserve, because the replace below overwrites state
preserve

* five state names are stored short. "\." means "contains a full stop"
list state state2 if regexm(state, "\.")

* substr pulls out the part after the abbreviation
generate state3 = substr(state, 4, strlen(state)) if regexm(state, "\.")

* inlist is the readable way to say "any of these"
replace state = "South" if inlist(state2, "SC", "SD")

* put the data back the way it was
restore


*** 3.7 Labels

* a title for the dataset, and a readable name for one variable
label data "1980 US Census, State Level"
label variable coastal "On a Coast"

* look at the table before
tabulate coastal border

* define a named set of value labels once, then apply it to both
label define yn_dummy 0 "No" 1 "Yes"
label values coastal border yn_dummy

* and after
tabulate coastal border

* same numbers, readable table. the values underneath did not move


*** 3.7 ADVANCED - not for today. Editing a label that already exists.

* region arrived with a value label called cenreg
tabulate region

* , modify edits an existing set instead of defining a new one
label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
tabulate region

* nolabel shows the numbers underneath. it is singular; nolabels errors
tabulate region, nolabel


*** 3.8 Groups

* _n is this row's number, _N is the total row count
generate nval = _n
generate nvals = _N
list state nval nvals in 1/3

* drop them again
drop nval*

* bysort runs a command once per region, which changes what _N counts
bysort region: generate region_states = _N
bysort region: generate nval = _n
bysort region: egen region_pop = sum(pop)

* nval == 1 keeps the first row of each region. four rows, not fifty
list region region_states region_pop if nval == 1

* egen's mean, against the total divided by the count. they match
bysort region: egen region_pop_mean = mean(pop)
generate region_pop_mean2 = region_pop / region_states
list region region_pop_mean region_pop_mean2 if nval == 1

* format changes how a number is displayed, never its value
format region_pop %15.0fc
list region region_states region_pop if nval == 1


*** 3.9 Log Files

* capture = try it, and do not stop the file if it fails
capture log close

* , text or the file fills with Stata markup. , replace to run twice
log using "test_log.txt", text replace

* anything printed from here on lands in the log as well as on screen
display "This is a test."
display 1 + 1

* close it, or it stays open and the next run fails
log close

* the cleaned data, under a new name
save "first_looks_clean.dta", replace



