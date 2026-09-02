* =====================================================================
*  Block 5 - Reshape wide to long
*  The reverse of Block 4. One row per state becomes one row per
*  state-year again - back to the stacked shape Block 2 built.
*
*  Opens:  block5.dta       51 obs, 34 vars  (state, year-wide)
*  Result:                 153 obs, 13 vars  (state-year)
*
*  This file stands on its own.
* =====================================================================

clear all
set more off

capture confirm file "block5.dta"
if _rc {
	capture cd ..
	confirm file "block5.dta"
}

* ---------------------------------------------------------------------
*  The task
* ---------------------------------------------------------------------
use block5, clear
describe, short

isid statefip

reshape long pop white black hispanic asian native mix_other ///
	age_prek age_minor age_working age_senior, i(statefip) j(year)

* 51 rows became 153, 34 variables became 13. This is the same shape as
* state_long.dta from Block 3 - you are back where you started, which is
* the point: wide and long hold the same data.
describe

* Optional. You already have this data from Block 3, so saving it again
* is practice rather than necessity.
save state_long_v2, replace

* ---------------------------------------------------------------------
*  If you had time. Nothing below is saved.
* ---------------------------------------------------------------------

* Symmetry has a limit, and this is where it breaks.
*
* reshape WIDE takes a varlist, so age* expands to the four age
* variables exactly as you would expect.
*
* reshape LONG takes STUBNAMES - the part of the name left over once the
* year is stripped off. An asterisk is not legal in a name, so Stata
* rejects it while parsing, before it ever looks for a variable.
*
* This command is MEANT to fail. capture noisily lets the rest of this
* file run anyway. You should see exactly:
*
*     * invalid name
*     r(198);
*
* If you got a different error, you made a different mistake.
use block5, clear
capture noisily reshape long pop white black hispanic asian native mix_other age*, ///
	i(statefip) j(year)
display "expected failure, return code = " _rc
assert _rc == 198
