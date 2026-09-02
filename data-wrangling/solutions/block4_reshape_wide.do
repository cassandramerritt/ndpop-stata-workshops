* =====================================================================
*  Block 4 - Reshape long to wide
*  Same data, different shape: one row per state-year becomes one row
*  per state, with a column per year.
*
*  Opens:  block4.dta      153 obs, 13 vars  (state-year)
*  Saves:  state_wide.dta   51 obs, 34 vars  (state, year-wide)
*
*  This file stands on its own.
* =====================================================================

clear all
set more off

capture confirm file "block4.dta"
if _rc {
	capture cd ..
	confirm file "block4.dta"
}

* ---------------------------------------------------------------------
*  The task
* ---------------------------------------------------------------------
use block4, clear
describe, short

* reshape needs i() to identify a row uniquely. Check it first - a
* failed reshape is much harder to read than a failed isid.
isid statefip year

reshape wide pop white black hispanic asian native mix_other ///
	age_prek age_minor age_working age_senior, i(statefip) j(year)

* 153 rows became 51: one per state. 13 variables became 34: statefip,
* plus each of the other 11 once per year (11 x 3 = 33).
describe

save state_wide, replace

* ---------------------------------------------------------------------
*  If you had time. Nothing below is saved.
* ---------------------------------------------------------------------

* Reshape on state instead of year. Nothing is wrong with this command -
* it just answers a different question, and the answer is a dataset with
* 3 rows and one column per state per variable. Shape follows i() and
* j(); it is your choice, not a property of the data.
use block4, clear
isid statefip year
reshape wide pop white black hispanic asian native mix_other ///
	age_prek age_minor age_working age_senior, i(year) j(statefip)
describe, short
