* =====================================================================
*  Block 2 - Append
*  Stacking observations: three separate years become one dataset.
*
*  Opens:  block2_1980.dta    51 obs, 9 vars  (state, race/eth, 1980)
*          block2_1990.dta, block2_2000.dta
*  Saves:  state_race.dta    153 obs, 9 vars  (state-year, race/eth)
*
*  This file stands on its own.
* =====================================================================

clear all
set more off

capture confirm file "block2_1980.dta"
if _rc {
	capture cd ..
	confirm file "block2_1980.dta"
}

* ---------------------------------------------------------------------
*  The task
* ---------------------------------------------------------------------
use block2_1980, clear
describe, short

append using block2_1990
describe, short

append using block2_2000

* 51 + 51 + 51 = 153. The variables did not change - append adds rows,
* not columns. That only works because all three files use the same
* variable names and the same types.
describe

save state_race, replace

* ---------------------------------------------------------------------
*  Second pass: both files in one append. Same result, one command.
*  Not saved.
* ---------------------------------------------------------------------
use block2_1980, clear
append using block2_1990 block2_2000
describe, short

* ---------------------------------------------------------------------
*  If you had time. Nothing below is saved.
* ---------------------------------------------------------------------

* Build the stack without use at all: start from nothing and append
* every file, 1980 included.
clear
append using block2_1980
append using block2_1990
append using block2_2000
describe, short

* The same thing as a loop. Loops belong in the do-file editor, not the
* command window - a multi-line loop typed at the prompt is painful.
clear
foreach y in 1980 1990 2000 {
	append using block2_`y'
}
describe, short
