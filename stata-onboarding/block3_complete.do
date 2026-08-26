* block3_complete.do
* Cleaning the 1980 Census state data - ANSWER KEY
* Every blank from block3_student.do filled in.

* Run it a line at a time with Ctrl-D (Windows) / Cmd-Shift-D (Mac) and read
* what each line does. That is a perfectly good way to learn this.

clear all

* Set your working directory, or just make sure Stata is already pointed at
* the folder holding first_looks.dta. Forward slashes, even on Windows.
* cd "C:/Users/yourname/Documents/Stata Workshop"

pwd
dir

use "first_looks.dta", clear


* Add the four age groups together and call it check_pop.
generate check_pop = poplt5 + pop5_17 + pop18p + pop65p

* Compare it against pop. The means differ: 4,518,149 vs 5,027,652.
summarize pop check_pop

* Now make Stata check it instead of your eyes.
*
* THIS LINE FAILS ON PURPOSE, and it stops the do-file dead:
*     50 contradictions in 50 observations
*     assertion is false
*     r(9);
*
* That halt is the entire point of assert. A summary table you skim past is
* easy to ignore. A file that refuses to continue is not.
*
* It is commented out here so the rest of this answer key can run. Uncomment
* it and run it once - you should see it stop.
*
* assert pop == check_pop

* Why it failed: pop18p is "18 and older", which ALREADY includes everyone in
* pop65p. We counted the over-65s twice.

* Redefine check_pop as just the first three age groups.
* The variable already exists, so this is replace, not generate.
replace check_pop = poplt5 + pop5_17 + pop18p

summarize pop check_pop

* Check again. This one passes, and prints nothing at all.
* Silence from assert means success.
assert pop == check_pop


* optional
* The same check from the other side. Also where rename and drop show up.
generate pop18_65 = pop18p - pop65p
rename pop18_65 pop18_64
generate check2_pop = poplt5 + pop5_17 + pop18_64 + pop65p
summarize pop check2_pop
assert pop == check2_pop
drop check_pop check2_pop


* Population in millions, rounded to one decimal.
generate pop_m = pop / 1000000
replace pop_m = round(pop_m, .1)

help functions


* Percentiles. detail is the option that adds them.
summarize pop, detail

* Everything summarize just computed is still sitting in memory.
return list

* r(p90) is the 90th percentile. The parentheses make the test come out as 1/0.
generate big_state = (pop >= r(p90))

* CAREFUL: r() results are overwritten by the next command that returns
* anything. Use them immediately, or store them somewhere first.

list state pop if big_state == 1


* optional
* Same answer, different route. egen is a library of ready-made calculations.
egen big_state2 = pctile(pop), p(90)
replace big_state2 = pop >= big_state2
assert big_state == big_state2
drop big_state2


* Strings. Demonstration only - you are not expected to write these.
* Five state names are stored short: N. Carolina, N. Dakota, S. Carolina,
* S. Dakota, W. Virginia.
list state state2 if regexm(state, "\.")

* regexm() matches a regular expression. "\." means "contains a full stop".
* Note: some code uses regexmatch() instead. That one needs Stata 18 or newer.
* regexm() works in every version, so prefer it.

generate state3 = substr(state, 4, strlen(state)) if regexm(state, "\.")
list state state2 state3 if !missing(state3)

* This next line is wrong on purpose. "SD" on its own is not a test - Stata
* needs a full comparison on both sides of the | . It gives:
*     type mismatch
*     r(109);
*
* replace state = "South" if state2 == "SC" | "SD"

* inlist() is the clean way to say "any of these".
replace state = "South" if inlist(state2, "SC", "SD")
replace state = "North" if inlist(state2, "NC", "ND")


* Labels. Three kinds, broadest to narrowest.
label data "1980 US Census, State Level"

label variable state "State Name"
label variable state2 "State Abbreviation"
label variable coastal "On a Coast"
label variable border "On an Int'l Border"

* Value labels work differently: define a named set, then apply it to as many
* variables as you like.
tabulate coastal border

label define yn_dummy 0 "No" 1 "Yes"
label values coastal border yn_dummy

* Same numbers, readable table. Labels sit on top of the values; the
* underlying data has not changed.
tabulate coastal border


* optional
* region already arrived with a label set called cenreg. , modify edits it.
tabulate region
label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
tabulate region

* nolabel is SINGULAR. nolabels gives "option nolabels not allowed", r(198).
tabulate region, nolabel


* optional
* _n is this row's number. _N is the total number of rows.
generate nval = _n
generate nvals = _N
drop nval*

* Inside bysort, _N means "rows in this group" instead.
bysort region: generate region_states = _N
bysort region: generate nval = _n
bysort region: egen region_pop = sum(pop_m)

* nval == 1 prints one row per region instead of all 50.
list region region_states region_pop if nval == 1

bysort region: egen region_pop_mean = mean(pop_m)
generate region_pop_mean2 = region_pop / region_states

* Both columns match: egen's mean, and total/count worked out by hand.
list region region_pop_mean region_pop_mean2 if nval == 1


* Log files. The do-file is what you asked; the log is what Stata answered.

* capture = "try this, don't stop the file if it fails". Without this line,
* running the file twice fails with "log file already open".
capture log close

* , text matters. Leave it out and Stata writes its own markup format into
* your .txt file, and it opens looking broken.
* Also: the command is "log using", not "log open using".
log using "test_log.txt", text replace

display "This is a test."
display 1 + 1

log close


save "first_looks_clean.dta", replace
