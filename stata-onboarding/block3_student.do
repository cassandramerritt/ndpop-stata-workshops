* block3.do
* Cleaning the 1980 Census state data

* This is what a do-file looks like when you start one. Not much to it.
* Lines starting with * are comments. Stata ignores them, people read them.
* Run highlighted line(s) with Ctrl-D (Windows) or Cmd-Shift-D (Mac), 
* or the whole file if nothing is highlighted.

clear all

* Set your working directory. This is the one line only you can write.
* Forward slashes, even on Windows. Keep the quotes.
cd ""

pwd
dir

use "first_looks.dta", clear


* Add the four age groups together and call it check_pop


* Compare it against pop


* Now make Stata check it instead of your eyes.
* This is supposed to fail. Read the error, then we'll keep going.
assert pop == check_pop


* Redefine check_pop as just the first three age groups.
* The variable already exists, so this is not generate.


* Check again. Silence means it passed.



* optional
* The same check from the other side. This is also where rename and drop show up.
generate pop18_65 = pop18p - pop65p
rename pop18_65 pop18_64
generate check2_pop = poplt5 + pop5_17 + pop18_64 + pop65p
summarize pop check2_pop
assert pop == check2_pop
drop check_pop check2_pop


* Population in millions is easier to read. Divide pop by a million, call it pop_m.


* Round it to one decimal place. Use round(). This is a replace, not a generate.


help functions


* Get percentiles for pop. summarize takes an option for this.


* Everything summarize just computed is still in memory. Look at it.
return list


* r(p90) is the 90th percentile. Flag states at or above it.
* Put the test in parentheses so it comes out as 1/0.


* List the states you just flagged



* optional
* Same answer, different route.
egen big_state2 = pctile(pop), p(90)
replace big_state2 = pop >= big_state2
assert big_state == big_state2
drop big_state2


* Strings. Watch this one, don't type it.
* Five state names are stored short: N. Carolina, S. Dakota, W. Virginia and so on.
list state state2 if regexm(state, "\.")
generate state3 = substr(state, 4, strlen(state)) if regexm(state, "\.")

* This one is wrong on purpose. "SD" by itself is not a test.
* replace state = "South" if state2 == "SC" | "SD"
replace state = "South" if inlist(state2, "SC", "SD")


* Labels. Three kinds.
label data "1980 US Census, State Level"

label variable coastal "On a Coast"

* Value labels work differently. Define a set, then apply it.
tabulate coastal border

label define yn_dummy 0 "No" 1 "Yes"
label values coastal border yn_dummy

* Same numbers, readable table.
tabulate coastal border


* optional
* region already came with a label set called cenreg. Edit it in place.
tabulate region
label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
tabulate region
* nolabel is singular. nolabels errors.
tabulate region, nolabel


* optional
* _n is this row's number. _N is the total number of rows.
generate nval = _n
generate nvals = _N
drop nval*

* Inside bysort, _N means rows in this group instead.
bysort region: generate region_states = _N
bysort region: generate nval = _n
bysort region: egen region_pop = sum(pop_m)

* nval == 1 prints one row per region instead of all 50.
list region region_states region_pop if nval == 1

bysort region: egen region_pop_mean = mean(pop_m)
generate region_pop_mean2 = region_pop / region_states
list region region_pop_mean region_pop_mean2 if nval == 1


* Log files. The do-file is what you asked. The log is what Stata answered.
* capture means try it and don't stop the file if it fails.
* Without this line, running twice fails with "log file already open".
capture log close

* , text matters. Without it you get Stata markup in a .txt file.
log using "test_log.txt", text replace

display "This is a test."
display 1 + 1

log close


* Save your work.
save "first_looks_clean.dta", replace
