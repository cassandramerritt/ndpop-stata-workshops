* =====================================================================
*  Block 3 - Merge
*  Joining variables: race/ethnicity and age groups, matched on keys.
*
*  Opens:  block3a.dta   153 obs,  9 vars  (state-year, race/eth)
*          block3b.dta   153 obs,  7 vars  (state-year, age groups)
*  Saves:  state_long.dta 153 obs, 13 vars (state-year, both)
*
*  This file stands on its own.
* =====================================================================

clear all
set more off

capture confirm file "block3a.dta"
if _rc {
	capture cd ..
	confirm file "block3a.dta"
}

* ---------------------------------------------------------------------
*  The task
* ---------------------------------------------------------------------
use block3a, clear

* Before merging, confirm the key really is a key. isid is silent when
* it holds and stops the do-file when it does not.
isid year statefip

merge 1:1 year statefip using block3b

* _merge is the point of the exercise, not clutter. Read it before you
* do anything else: 3 means matched in both, 1 means master only,
* 2 means using only. Here all 153 rows should be 3.
tab _merge
assert _merge == 3

* pop is in BOTH files and holds identical values, so nothing was
* overwritten and nothing was lost. Stata keeps the master's copy by
* default. The update and update replace options change that - see the
* last suggestion below, where the values genuinely differ.

* _merge is sometimes worth keeping, to build a flag from. If you keep
* it, rename it with merge's generate() option rather than leaving the
* default name lying around for the next merge to collide with. Here we
* have checked it, so drop it.
drop _merge

describe

save state_long, replace

* ---------------------------------------------------------------------
*  Second pass: a many-to-one merge. Every state-year row gets the
*  region its state belongs to. Not saved.
* ---------------------------------------------------------------------
use block3a, clear
merge m:1 statefip using xwalk_statefip_region
tab _merge
describe, short

* ---------------------------------------------------------------------
*  If you had time. Nothing below is saved.
* ---------------------------------------------------------------------

* The same join from the other side. Master and using swap, so m:1
* becomes 1:m. The result is the same rows; the direction is what
* changed. joinby handles the many-to-many case, which merge refuses.
use xwalk_statefip_region, clear
merge 1:m statefip using block3a
tab _merge

* Suppress the merge indicator, or give it a name of your own.
use block3a, clear
merge 1:1 year statefip using block3b, nogenerate
describe, short

use block3a, clear
merge 1:1 year statefip using block3b, generate(matched_age)
tab matched_age

* A deliberately WRONG merge, run to see what update and replace do.
* 1980 race data as master, 1990 age data as using, matched on state
* alone - so a state's 1980 row is joined to its own 1990 row. Both
* files carry pop, and here the values genuinely differ: 1980
* population in the master, 1990 population in the using file. That
* collision is the whole point.
use block2_1980, clear
list statefip year pop in 1/5

* Plain merge: master wins, pop stays at its 1980 value.
merge 1:1 statefip using block3b_1990
list statefip year pop in 1/5
drop _merge

* update: the using file fills in only where the master is missing.
* Nothing is missing here, so nothing changes.
use block2_1980, clear
merge 1:1 statefip using block3b_1990, update
list statefip year pop in 1/5
drop _merge

* update replace: the using file overwrites the master. pop becomes the
* 1990 value - and so does year, which silently relabels every 1980 row
* as 1990. That is the sharper half of the lesson. Do not do this to
* real data; run it once to see what the option is capable of.
use block2_1980, clear
merge 1:1 statefip using block3b_1990, update replace
list statefip year pop in 1/5

* Key types have to match. FIPS codes are identifiers, not quantities:
* stored as a number, California's 06 becomes 6 and the leading zero is
* gone. A string key will never match a numeric one. Today's files are
* already consistent, so none of this is needed - but it is the first
* thing to check when a merge that should work does not.
use block3a, clear

* tostring changes the TYPE. That is only half the job: it gives you
* "6", not "06".
tostring statefip, generate(statefip_str)
list statefip statefip_str in 1/3

* Padding puts the zero back, and padding is the part that actually
* makes a FIPS key match.
replace statefip_str = "0" + statefip_str if strlen(statefip_str) == 1
list statefip statefip_str in 1/3

* destring goes the other way - and drops the leading zero again, which
* is exactly the trap.
destring statefip_str, replace
list statefip statefip_str in 1/3
