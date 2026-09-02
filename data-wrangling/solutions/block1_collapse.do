* =====================================================================
*  Block 1 - Collapse
*  Changing the unit of observation: county level -> state level.
*
*  Opens:  block1_1980.dta   390 obs, 10 vars  (state-county, race/eth)
*  Saves:  state_1980.dta     51 obs,  9 vars  (state, race/eth)
*
*  This file stands on its own. Run it if you fell behind, or afterwards
*  to review. It does not depend on any other block.
* =====================================================================

clear all
set more off

* Find the data whether you ran this from the workshop folder or by
* double-clicking it inside solutions/.
capture confirm file "block1_1980.dta"
if _rc {
	capture cd ..
	confirm file "block1_1980.dta"
}

* ---------------------------------------------------------------------
*  The task
* ---------------------------------------------------------------------
use block1_1980, clear

* One row per county. pop and the race/ethnicity counts are already
* weighted population estimates - perwt was applied when this data was
* built, so there is no [pw=] to add here.
describe, short

collapse (sum) pop white black hispanic asian native mix_other, by(year statefip)

* 51 rows, one per state plus DC. fips5 is gone: collapse keeps only the
* by() variables and the variables you named a statistic for.
describe

save state_1980, replace

* ---------------------------------------------------------------------
*  Second pass: more than one statistic in a single collapse.
*  Not saved - state_1980.dta above is what Block 2 opens.
* ---------------------------------------------------------------------
use block1_1980, clear

collapse (sum) pop white black hispanic asian native mix_other ///
	(mean) avg_county_pop = pop (max) largest_county = pop, by(year statefip)

describe

* ---------------------------------------------------------------------
*  If you had time. Nothing below is saved.
* ---------------------------------------------------------------------

* National totals: collapse by year alone, and 51 rows become 1.
use block1_1980, clear
collapse (sum) pop white black hispanic asian native mix_other, by(year)
list

* State averages across all three decades. block4.dta is the merged
* panel you build in Block 3 - a look ahead at where this is going.
use block4, clear
collapse (mean) pop white black hispanic asian native mix_other, by(statefip)
describe
