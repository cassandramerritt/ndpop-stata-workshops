* =====================================================================
*  Data Wrangling with Stata - take-home do-file
*
*  The whole session, start to finish, with every command filled in and
*  commented. Run it a line at a time (Ctrl-D on Windows, Cmd-Shift-D
*  on Mac) and read what each step does to the data.
*
*  It runs clean from top to bottom. Nothing here needs the workshop.
*
*  The one deliberate exception is at the very end: a command that is
*  MEANT to fail, wrapped so it does not stop the file.
* =====================================================================

clear all
set more off

* This assumes Stata's working directory is the workshop folder - which
* it is if you got here by double-clicking a file inside it. Check with:
pwd
dir *.dta


* =====================================================================
*  BLOCK 1 - COLLAPSE
*  Changing the unit of observation: counties become states.
* =====================================================================

use block1_1980, clear

* 390 rows, one per county. Note fips5: the 5-digit county identifier.
describe, short

* The counts here are already weighted population estimates. The survey
* weight was applied when this file was built, so there is nothing to
* add.
list year statefip fips5 pop white black in 1/5

* collapse needs two things: a statistic for each variable you want to
* keep, and the group to compute it within.
collapse (sum) pop white black hispanic asian native mix_other, by(year statefip)

* 51 rows now - one per state plus DC. And fips5 is GONE. collapse keeps
* the by() variables and the ones you gave a statistic for. Everything
* else is dropped, silently. This catches people out.
describe

save state_1980, replace


* =====================================================================
*  BLOCK 2 - APPEND
*  Stacking observations: three years become one dataset.
* =====================================================================

use block2_1980, clear
describe, short

* append adds ROWS. The files must share variable names and types.
append using block2_1990
append using block2_2000

* 51 + 51 + 51 = 153 rows. Still 9 variables - append does not add
* columns. You could also have written:
*     append using block2_1990 block2_2000
describe

save state_race, replace


* =====================================================================
*  BLOCK 3 - MERGE
*  Joining variables: two sources, matched row to row on a key.
* =====================================================================

use block3a, clear

* Before merging, confirm the key really identifies a row uniquely.
* isid says nothing when it holds and stops the file when it does not,
* which is exactly what you want.
isid year statefip

* 1:1 because one row on each side. Use m:1 or 1:m when one side repeats.
merge 1:1 year statefip using block3b

* _merge is the evidence that the join did what you meant. Read it
* before anything else.
*     1 = in master only    2 = in using only    3 = matched both
tab _merge
assert _merge == 3

* pop exists in BOTH files here. The values happen to be identical, so
* nothing was lost - merge keeps the master's copy and discards the
* other. The update and replace options change that behaviour; see the
* bottom of this file for what they actually do.

* If you wanted to keep the merge indicator, you would name it as it is
* created - merge ..., generate(myflag) - rather than leaving the
* default name for your next merge to collide with. We have checked it,
* so drop it.
drop _merge

* 153 rows, 13 variables. The state-year panel.
describe

save state_long, replace


* =====================================================================
*  BLOCK 4 - RESHAPE LONG TO WIDE
*  One row per state-year becomes one row per state.
* =====================================================================

use block4, clear
describe, short

* reshape uses i() to identify a row in the RESULT. Check it first: a
* failed isid is far easier to read than a failed reshape.
isid statefip year

*   i()  the variable identifying a row in the result
*   j()  the variable whose VALUES become part of the new column names
reshape wide pop white black hispanic asian native mix_other ///
	age_prek age_minor age_working age_senior, i(statefip) j(year)

* 153 rows became 51. 13 variables became 34: statefip, plus each of the
* other 11 once per year. pop is now pop1980, pop1990, pop2000.
describe

save state_wide, replace


* =====================================================================
*  BLOCK 5 - RESHAPE WIDE TO LONG
*  The reverse. Same varlist, same options, one word different.
* =====================================================================

use block5, clear
describe, short

isid statefip

reshape long pop white black hispanic asian native mix_other ///
	age_prek age_minor age_working age_senior, i(statefip) j(year)

* Back to 153 rows and 13 variables - the shape you had after Block 3.
* Wide and long hold the same data; only the shape differs.
describe


* =====================================================================
*  THINGS WORTH KNOWING, THAT THE SESSION ONLY MENTIONED
* =====================================================================

* --- Merge direction ------------------------------------------------
* Many state-year rows, one row per state in the crosswalk: m:1.
use block3a, clear
merge m:1 statefip using xwalk_statefip_region
tab _merge
drop _merge

* The same join from the other side. Swap master and using, and m:1
* becomes 1:m. Same result, opposite direction.
use xwalk_statefip_region, clear
merge 1:m statefip using block3a
tab _merge

* joinby handles many-to-many, which merge refuses outright. You need it
* when neither side is unique - counties split across commuting zones,
* for instance.


* --- What update and replace actually do ----------------------------
* A DELIBERATELY WRONG merge, run only to expose the options. 1980 race
* data as master, 1990 age data as using, matched on state alone - so a
* state's 1980 row is joined to its own 1990 row. Both files carry pop,
* and here the values genuinely DIFFER. Do not do this to real data.

use block2_1980, clear
list statefip year pop in 1/5

* Plain merge: the master wins. pop stays at its 1980 value.
merge 1:1 statefip using block3b_1990
list statefip year pop in 1/5

* update: the using file fills in only where the master is MISSING.
* Nothing is missing, so nothing changes.
use block2_1980, clear
merge 1:1 statefip using block3b_1990, update
list statefip year pop in 1/5

* update replace: the using file OVERWRITES the master. pop becomes the
* 1990 value - and so does year, silently relabelling every 1980 row as
* 1990. That second effect is the one to remember.
use block2_1980, clear
merge 1:1 statefip using block3b_1990, update replace
list statefip year pop in 1/5


* --- Keys have to match in type -------------------------------------
* FIPS codes are identifiers, not quantities. Stored as a number,
* California's 06 becomes 6 and the leading zero is gone. A string key
* will never match a numeric one.
use block3a, clear

* tostring changes the TYPE, and that is only half the job: it gives you
* "6", not "06".
tostring statefip, generate(statefip_str)
list statefip statefip_str in 1/3

* Padding puts the zero back. This is the line that actually makes a
* FIPS key usable, and it is a separate step from the type change.
replace statefip_str = "0" + statefip_str if strlen(statefip_str) == 1
list statefip statefip_str in 1/3

* destring converts back to a number - and drops the leading zero again.
* That is the trap, and it is why IDs belong in strings.
destring statefip_str, replace
list statefip statefip_str in 1/3


* --- Where the symmetry breaks --------------------------------------
* reshape WIDE takes a varlist, so age* expands to the four age
* variables. reshape LONG takes STUBNAMES - the part of the name left
* after the year is stripped off - and an asterisk is not legal in a
* name, so Stata rejects it while parsing.
*
* The command below is MEANT to fail. capture noisily prints the error
* without stopping the file. You should see exactly:
*
*     * invalid name
*     r(198);

use block5, clear
capture noisily reshape long pop white black hispanic asian native mix_other age*, ///
	i(statefip) j(year)
display "expected failure, return code = " _rc
assert _rc == 198

display _n "Take-home do-file complete."
