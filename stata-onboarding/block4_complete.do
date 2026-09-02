*** =====================================================================
***  Block 4 - First Output from Raw Input          ANSWER KEY
***  Google Trends search interest: Notre Dame, MIT, Clemson.
***
***  Opens:  google_trends_universities.csv   272 rows, 4 columns
***  Saves:  uni_trends.dta, and three .png figures
***
***  Every blank from block4_student.do, filled in, with comments on why.
***  Run it a line at a time and read what each one does.
*** =====================================================================

clear all
set more off

* Find the data whether you are in the workshop folder already or one
* level down inside it.
capture confirm file "google_trends_universities.csv"
if _rc {
	capture cd ..
	confirm file "google_trends_universities.csv"
}


***** IMPORT

* 1. The command is not use - that is for .dta files. This is a CSV.
import delimited using "google_trends_universities.csv", clear

* 2. Look at what arrived.
describe
list in 1/5
summarize

* WHAT INSPECTION ALONE TELLS YOU
*   - 272 rows, 4 columns.
*   - One row is one MONTH, running 2004 to 2026. So: a time series.
*   - Three columns of numbers, one per university, roughly 0 to 100.
*
* WHAT IT DOES NOT TELL YOU
*   - The numbers are RELATIVE, not counts. Google scales them so the
*     single highest point across the three search terms is 100. Notre
*     Dame holds that peak, so the other two never reach it. That does
*     NOT mean the others are small - it means they never out-searched
*     Notre Dame's best month.
*   - Nothing here counts people.
*
* That gap is the point of inspecting first. You can read the SHAPE of a
* dataset off the screen. You cannot read its MEANING.
*
* And the question from Block 2, again: what is one row? There it was
* one state. Here it is one month. Same question, different unit - and
* it is the question Workshop 2 is built on.


***** CLEAN

* 3. time came in as TEXT. Stata cannot sort it, plot it, or do
*    arithmetic on it until it is a real date. Two commands: build the
*    date, then format it so it displays as one.
generate date = date(time, "YMD")
format date %td

* Dates are numbers wearing a costume. Underneath, 01jan2004 is 16071 -
* the number of days since 1 January 1960, which is day zero for Stata.

* 4. The data is monthly, so a daily date is more precision than you
*    want. Make a monthly version and format that too.
generate month_date = mofd(date)
format month_date %tm

* 5. Put time and the new date variables at the front.
order time date

* 6. Rename the three interest variables to something you can type.
*    describe showed one of them as massachusettsinstituteoftechnolo -
*    truncated, because Stata variable names stop at 32 characters.
*    All three rename in one command.
rename (universityofnotredame massachusettsinstituteoftechnolo clemsonuniversity) ///
	(nd_interest mit_interest clemson_interest)

* 7. Label the three variables, so the graphs come out readable.
label variable nd_interest "University of Notre Dame Interest (Google Trends)"
label variable mit_interest "Massachusetts Institute of Technology Interest (Google Trends)"
label variable clemson_interest "Clemson University Interest (Google Trends)"

* 8. Label the dataset as a whole.
label data "Google Trends search interest for three universities, 2004-2026. Normalized to peak interest."

* 9. Tell Stata this is time-series data, indexed by the monthly
*    variable. Without this, tsline in step 17 will not work.
tsset month_date, monthly

* 10. Save. Two things people forget: quotes if the path has a space,
*     and , replace or it fails the second time you run the file.
save "uni_trends.dta", replace


***** ANALYZE

* 11. Correlate the three interest variables. The wildcard names all
*     three at once.
correlate *_interest

* 12. Regress Notre Dame interest on Clemson interest, robust standard
*     errors.
regress nd_interest clemson_interest, robust

* Two lines, and a semester of knowing when they are the right two.


***** VISUALIZE

* 13. A scatter of Notre Dame against Clemson.
scatter nd_interest clemson_interest

* 14. The same, with a fitted line. twoway takes two pieces in
*     parentheses; legend(pos(6)) puts the legend at the bottom.
twoway (scatter nd_interest clemson_interest) ///
	(lfit nd_interest clemson_interest), ///
	legend(pos(6))

* 15. The same plot for a different school. One small change from 13.
scatter nd_interest mit_interest

* 16. Both comparisons on ONE graph - two scatters layered. Without
*     legend(order(...)) Stata labels both series "nd_interest", which
*     is useless.
twoway (scatter nd_interest clemson_interest) ///
	(scatter nd_interest mit_interest), ///
	legend(order(1 "Clemson" 2 "MIT")) ///
	xtitle("Other University Interest")

* 17. All three schools over time, as lines. This is the one that needed
*     the tsset in step 9.
tsline nd_interest clemson_interest mit_interest, legend(rows(3))


***** PROVIDED - read these, run them, take them apart

* Nobody writes a graph this long from memory. They get built one option
* at a time, starting from what you typed in 13-17. Run it, delete an
* option, run it again and see what that option was doing.

twoway (scatter nd_interest clemson_interest, mcolor(orange)) ///
	(scatter nd_interest mit_interest, mcolor(cranberry)) ///
	(lfit nd_interest clemson_interest, lcolor(orange)) ///
	(lfit nd_interest mit_interest, lcolor(cranberry)), ///
	legend(pos(6) order(1 "Clemson" 2 "MIT")) ///
	ytitle("Notre Dame Interest") ///
	xtitle("Other University Interest") ///
	name(trends_scatter, replace)

* /// at the end of a line means "this command continues below".
* Without it, Stata reads each line as its own command.

* 18. Export it. Doing this straight after drawing is the safe habit: in
*     a batch run, graph export can only reach the graph currently
*     displayed. Interactively each named graph has its own window, so
*     you can export any of them at any time.
graph export "trends_scatter.png", replace

* The last eight years only, with a marker on every September.
tsline nd_interest clemson_interest mit_interest in 170/272, ///
	legend(order(1 "Notre Dame" 2 "Clemson" 3 "MIT") rows(3)) ///
	lcolor(navy cranberry orange) ///
	tline(2018m9 2019m9 2020m9 2021m9 2022m9 2023m9 2024m9 2025m9) ///
	ttext(90 2018m7 "Sept" 90 2019m7 "Sept" 90 2020m7 "Sept" 90 2021m7 ///
	"Sept" 90 2022m7 "Sept" 90 2023m7 "Sept" 90 2024m7 "Sept" 90 2025m7 "Sept", ///
	orient(vert)) ///
	name(seasons_tsline, replace)

* in 170/272 filters by row POSITION, not by date. 272 is the last row.
* Every September the Notre Dame line jumps. Football season.


***** REPORT

* 19. Export that one too, then combine both into a single image and
*     export that as well.
graph export "seasons_tsline.png", replace

graph combine trends_scatter seasons_tsline, name(combo_trends, replace)
graph export "combo_trends.png", replace

display _n "Block 4 complete."
