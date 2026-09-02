* =====================================================================
*  Block 3 - Your First Stata Project
*  Cleaning the 1980 Census state data.
*
*  Opens:  first_looks.dta   50 obs, 16 vars  (one row per state)
*  Saves:  first_looks_clean.dta
*
*  YOU write the commands. Each comment says what to do and names the
*  command in brackets; you work out the syntax. The handout has the
*  same steps with the results you should see.
*
*  Run the highlighted line(s) with Ctrl-D (Windows) / Cmd-Shift-D
*  (Mac), or the whole file if nothing is highlighted.
*
*  Stuck? block3_complete.do has every answer.
*
*  Sections marked ADVANCED are not part of the session, and are given
*  to you complete. Run them afterwards.
* =====================================================================

clear all
set more off

capture confirm file "first_looks.dta"
if _rc {
	capture cd ..
	confirm file "first_looks.dta"
}

local startdir "`c(pwd)'"


* ---------------------------------------------------------------------
*  3.1  Where Stata is working
* ---------------------------------------------------------------------
* You opened start_here.do by double-clicking, so Stata is already
* pointed at this folder. If pwd says otherwise, cd to it - start_here.do
* explains how.
pwd

* ADVANCED - not for today.
* Two shorthands: . is where you are, .. is one level up.
cd .
pwd
cd ..
pwd
qui cd "`startdir'"
pwd

use "first_looks.dta", clear


* ---------------------------------------------------------------------
*  3.2  What a do-file starts with
* ---------------------------------------------------------------------
* Lines starting with * are comments. Stata ignores them; people read
* them. Fill in your own name and today's date on the line below - that
* is the whole exercise, and it is the thing people skip.
*
* block3.do
* Cleaning the 1980 Census state data
* your name, today's date


* ---------------------------------------------------------------------
*  3.3  Does the data add up?
* ---------------------------------------------------------------------
* Population is split by age: poplt5, pop5_17, pop18p, pop65p. Those
* four should total pop.

* 1. Add the four age groups together and call the result check_pop.
*    (generate)



* 2. Compare check_pop against pop. Use the summarizing command from 2.4.
*    Check: the means differ - 4,518,149 against 5,027,652.



* 3. Now make Stata check it instead of your eyes.
*    This line is SUPPOSED to fail, and it stops the do-file dead.
*    Read the error, then carry on below it.
assert pop == check_pop


* 4. Why did it fail? pop18p is "18 and older", which already includes
*    everyone in pop65p - the over-65s are counted twice. Redefine
*    check_pop as just the first three groups. It already exists, so
*    this is not generate. (replace)



* 5. Check again. Silence means it passed. (assert)



* 6. Build the same check from the other side: pop18p minus pop65p,
*    called pop18_65. (generate)



* 7. Is that name accurate? The group runs 18 to 64, not 18 to 65.
*    Fix it. (rename)



* 8. Build check2_pop from the four groups that no longer overlap,
*    assert it against pop, then remove both check variables.
*    (generate, assert, drop)





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

* 9.  Give the dataset a title. (label data)



* 10. Give coastal a readable name. (label variable)



* 11. Value labels work differently: you define a named set once, then
*     apply it to as many variables as you like. Run tabulate on coastal
*     and border, then define a set mapping 0 to "No" and 1 to "Yes",
*     apply it to both variables, and run the same tabulate again.
*     (tabulate, label define, label values, tabulate)
*     Check: same numbers, readable table. Labels sit on top of the
*     values; the data underneath has not moved.






* ADVANCED - not for today.
* region arrived with a value label already attached, called cenreg.
* , modify edits an existing set in place rather than defining a new one.
* nolabel is SINGULAR - nolabels gives "option nolabels not allowed",
* r(198).
* Note this changes how region prints for the rest of your session.
tabulate region
label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
tabulate region
tabulate region, nolabel


* ---------------------------------------------------------------------
*  3.8  Groups
* ---------------------------------------------------------------------
* _n is this row's number. _N is the total number of rows.

* 12. Create nval from _n and nvals from _N, look at the first few rows,
*     then drop them both. (generate, list, drop)
*     What are these two variables?




* 13. Put bysort region: in front of a command and Stata runs it once
*     per region - and inside it, _N means "rows in THIS region".
*     With bysort region:, create region_states from _N, nval from _n,
*     and region_pop as the total of pop in each region.
*     (generate, generate, egen with sum())




* 14. List one row per region instead of all 50, showing the region, its
*     number of states and its total population. (list ... if nval == 1)
*     Check: four rows - 9, 12, 16 and 13 states.
*     Inside bysort region:, what does _N mean now? And what is
*     if nval == 1 doing?



* The totals print in scientific notation because they are raw counts of
* people. format changes how a number is DISPLAYED, never its value:
format region_pop %15.0fc
list region region_states region_pop if nval == 1


* ---------------------------------------------------------------------
*  3.9  Log files
* ---------------------------------------------------------------------
* The do-file is what you asked. The log is what Stata answered.

* 15. Open a log called test_log.txt, print two things to it with
*     display, and close it. Three protections belong in there and the
*     exercise is working out where each goes: capture before the close,
*     , text on the opening, and , replace on the opening.
*     (capture log close, log using, display, display, log close)
*     Check: test_log.txt appears in your folder and opens as readable
*     text. Without , text you get a screenful of {smcl} markup.






* 16. Save your cleaned data as first_looks_clean.dta. (save)



display _n "Block 3 complete."
