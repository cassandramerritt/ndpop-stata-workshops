* =====================================================================
*  Block 3 - Your First Stata Project              ANSWER KEY
*  Cleaning the 1980 Census state data.
*
*  Opens:  first_looks.dta        50 obs, 16 vars  (one row per state)
*  Saves:  first_looks_clean.dta  50 obs           (labelled, checked)
*
*  Every blank from block3_student.do, filled in. Run it a line at a
*  time with Ctrl-D (Windows) / Cmd-Shift-D (Mac) and read what each
*  line does. That is a perfectly good way to learn this.
*
*  Sections marked ADVANCED are not part of the session. They are real,
*  working code, printed so you have it. Run them afterwards.
* =====================================================================

clear all
set more off

capture confirm file "first_looks.dta"
if _rc {
	capture cd ..
	confirm file "first_looks.dta"
}

* Remember where we started, so the cd demonstration below can put it
* back. c(pwd) is the current working directory.
local startdir "`c(pwd)'"


* ---------------------------------------------------------------------
*  3.1  Where Stata is working
* ---------------------------------------------------------------------
* Double-clicking first_looks.dta pointed Stata at this folder for you -
* that was the point of 2.9 - so a bare filename is enough. If pwd says
* otherwise, cd to the folder; do_not_start_here.do has the instructions.
pwd

* ADVANCED - not for today.
* Two shorthands: . is where you are, .. is one level up.
cd .
pwd
cd ..
pwd
* Back to where we started before carrying on.
qui cd "`startdir'"
pwd

use "first_looks.dta", clear


* ---------------------------------------------------------------------
*  3.2  What a do-file starts with
* ---------------------------------------------------------------------
* Lines starting with * are comments. Stata ignores them; people read
* them. This is what belongs at the top of every file you write:
*
*     * block3.do
*     * Cleaning the 1980 Census state data
*     * your name, today's date
*
* From here on you type into the do-file, not the Command window.


* ---------------------------------------------------------------------
*  3.3  Does the data add up?
* ---------------------------------------------------------------------
* Population is split by age: poplt5, pop5_17, pop18p, pop65p. Those
* four should total pop.

* 1. Add the four age groups together and call the result check_pop.
generate check_pop = poplt5 + pop5_17 + pop18p + pop65p

* 2. Compare it against pop.
summarize pop check_pop

* The means differ. Your eyes can catch that; they cannot catch it in a
* dataset with 200 variables. So make Stata check instead.
*
* 3. Make Stata check it instead of your eyes.
*
* THIS LINE FAILS ON PURPOSE, and it stops the do-file dead:
*
*     50 contradictions in 50 observations
*     assertion is false
*     r(9);
*
* That halt is the entire point of assert. A summary table you skim past
* is easy to ignore. A file that refuses to continue is not.
*
* It is commented out here so the rest of this key can run. Uncomment it
* and run it once - watching it stop is the lesson.
*
* assert pop == check_pop

* Why it failed: pop18p is "18 and older", which ALREADY includes
* everyone in pop65p. We counted the over-65s twice.

* 4. The variable exists, so this is replace, not generate.
replace check_pop = poplt5 + pop5_17 + pop18p

summarize pop check_pop

* 5. This one passes, and prints nothing at all. Silence means success.
assert pop == check_pop

* 6. The same check from the other side. This is also where rename and
*    drop show up.
generate pop18_65 = pop18p - pop65p

* 7. Is that name accurate? The group runs 18 to 64, not 18 to 65.
rename pop18_65 pop18_64

* 8. Build check2_pop from the four groups that no longer overlap.
generate check2_pop = poplt5 + pop5_17 + pop18_64 + pop65p
summarize pop check2_pop
assert pop == check2_pop

drop check_pop check2_pop


* ---------------------------------------------------------------------
*  3.4  ADVANCED - not for today.  Functions.
* ---------------------------------------------------------------------
* Stata evaluates maths expressions, and ships a library of functions
* for numbers, strings and dates. Nobody memorises the list. Knowing it
* exists, and how to search it, is the skill.
generate pop_m = pop / 1000000
replace pop_m = round(pop_m, .1)
help functions


* ---------------------------------------------------------------------
*  3.5  ADVANCED - not for today.  Stata remembers more than it shows.
* ---------------------------------------------------------------------
* Every command leaves its results in memory; return list shows them.
* They are overwritten by the next command that returns anything, so use
* them immediately or store them first. egen reaches the same answer by
* a different route, which is worth knowing because it usually does.
summarize pop, detail
return list
generate big_state = (pop >= r(p90))
list state pop if big_state == 1

egen big_state2 = pctile(pop), p(90)
replace big_state2 = pop >= big_state2
assert big_state == big_state2
drop big_state2


* ---------------------------------------------------------------------
*  3.6  ADVANCED - not for today.  Strings, and a little regex.
* ---------------------------------------------------------------------
* Five state names are stored short: N. Carolina, N. Dakota,
* S. Carolina, S. Dakota, W. Virginia. regexm() asks whether a string
* matches a pattern; "\." means "contains a full stop". You are not
* expected to write regular expressions - recognising one is enough.
*
* Note: some code uses regexmatch(). That needs Stata 18 or newer.
* regexm() works in every version, so prefer it.
*
* inlist() is the readable way to say "any of these". Writing it as
*     if state2 == "SC" | "SD"
* reads like English and is not valid: "SD" on its own is not a test,
* and Stata answers "type mismatch", r(109).
*
* preserve / restore because the replace below overwrites state, and you
* probably want your data back afterwards.
preserve
list state state2 if regexm(state, "\.")
generate state3 = substr(state, 4, strlen(state)) if regexm(state, "\.")
list state state2 state3 if !missing(state3)
replace state = "South" if inlist(state2, "SC", "SD")
list state state2 if inlist(state2, "SC", "SD")
restore


* ---------------------------------------------------------------------
*  3.7  Labels
* ---------------------------------------------------------------------
* Three kinds, broadest to narrowest: the dataset, a variable, and the
* values inside a variable.
* 9. Give the dataset a title.
label data "1980 US Census, State Level"

* 10. Give coastal a readable name.
label variable coastal "On a Coast"

* 11. Value labels work differently: define a named set once, then apply
*     it to as many variables as you like. Run the tabulate before and
*     after.
tabulate coastal border

label define yn_dummy 0 "No" 1 "Yes"
label values coastal border yn_dummy

tabulate coastal border

* Same numbers, readable table. Labels sit on top of the values; the
* data underneath has not moved.

* ADVANCED - not for today.
* region arrived with a value label already attached, called cenreg.
* , modify edits an existing set in place rather than defining a new one.
* nolabel is SINGULAR - nolabels gives "option nolabels not allowed",
* r(198).
tabulate region
label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
tabulate region
tabulate region, nolabel


* ---------------------------------------------------------------------
*  3.8  Groups
* ---------------------------------------------------------------------
* 12. _n is this row's number. _N is the total number of rows.
generate nval = _n
generate nvals = _N
list state nval nvals in 1/3
drop nval*

* 13. Put bysort region: in front of a command and Stata runs it once per
*     region - and inside it, _N means "rows in THIS region".
bysort region: generate region_states = _N
bysort region: generate nval = _n
bysort region: egen region_pop = sum(pop)

* 14. nval == 1 prints one row per region instead of all 50.
list region region_states region_pop if nval == 1

bysort region: egen region_pop_mean = mean(pop)
generate region_pop_mean2 = region_pop / region_states

* Both columns match: egen's mean, and total divided by count worked out
* by hand. This is the idea Workshop 2's collapse is built on.
list region region_pop_mean region_pop_mean2 if nval == 1

* The totals are raw counts of people, so they print in scientific
* notation. format changes how a number is DISPLAYED, never its value.
format region_pop %15.0fc
list region region_states region_pop if nval == 1


* ---------------------------------------------------------------------
*  3.9  Log files
* ---------------------------------------------------------------------
* The do-file is what you asked. The log is what Stata answered.

* 15. capture = "try this, and do not stop the file if it fails". Without
* this line, running the file twice fails with "log file already open".
capture log close

* , text matters. Leave it out and Stata writes its own markup format
* into your .txt file, and it opens looking broken.
* , replace matters too, or the second run fails on an existing file.
log using "test_log.txt", text replace

display "This is a test."
display 1 + 1

log close

* Open test_log.txt in a text editor. It is exactly what was on screen.

* 16. Save your cleaned data.
save "first_looks_clean.dta", replace

display _n "Block 3 complete."
