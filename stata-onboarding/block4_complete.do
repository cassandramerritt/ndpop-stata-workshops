*** block4_complete.do
*** Google Trends search interest: Notre Dame, MIT, Clemson - ANSWER KEY
*** Every blank from block4_student.do filled in.

clear all

* Set your working directory, or make sure Stata already points at the folder
* holding google_trends_universities.csv. Forward slashes, even on Windows.
* cd "C:/Users/yourname/Documents/Stata Workshop"


***** IMPORT

* 1. Import the CSV. Not "use" - that is for .dta files.
*    Check: 272 observations, 4 variables
import delimited using "google_trends_universities.csv", clear

* 2. Look at what arrived.
describe
list in 1/5
summarize

*    WHAT INSPECTION ALONE TELLS YOU
*    - 272 rows, 4 columns.
*    - One row is one MONTH, running 2004 to 2026. So: time series.
*    - Three columns of numbers, one per university, roughly 0 to 100.
*
*    WHAT IT DOES NOT TELL YOU - you have to be told, or go and find out
*    - These are Google Trends search-interest figures.
*    - They are RELATIVE, not counts. Google scales them so the single highest
*      point across the three search terms is 100. Notre Dame holds that peak,
*      so MIT tops out at 39 and Clemson at 70. That does NOT mean "MIT is
*      small" - it means MIT never out-searched Notre Dame's best month.
*    - Nothing here counts people.
*
*    That gap is the point of inspecting first. You can read the SHAPE of a
*    dataset off the screen; you cannot read its MEANING. For that you need
*    documentation, the person who gave it to you, or the source.
*
*    In Block 2 one row was one state. Here it is one month. Every dataset has
*    a unit like that, and finding it is the first thing to do with any data
*    you are handed. Workshop 2 is built on that question.


***** CLEAN

* 3. time came in as TEXT. Stata cannot sort, plot, or do arithmetic on it
*    until it is a real date. Two steps: build the date, then format it.
*    date() reads the text; "YMD" tells it the order the parts come in.
generate date = date(time, "YMD")
format date %td

*    Before the format line, date reads 16071 - the number of days since
*    1 January 1960, which is day zero for Stata. After it, 01jan2004.
*    Dates are just numbers wearing a costume.

* 4. The data is monthly, so a daily date is more precision than you need.
*    mofd() = "month of date".
generate month_date = mofd(date)
format month_date %tm

* 5. Put the date variables at the front.
order time date

* 6. Rename all three in one command. Note the two sets of parentheses:
*    old names in the first, new names in the second, in the same order.
*    massachusettsinstituteoftechnolo was truncated by the import - Stata
*    variable names cap out at 32 characters.
rename (universityofnotredame massachusettsinstituteoftechnolo clemsonuniversity) ///
	(nd_interest mit_interest clemson_interest)

* 7. Label the variables so the graphs come out readable.
label variable nd_interest "University of Notre Dame Interest (Google Trends)"
label variable mit_interest "Massachusetts Institute of Technology Interest (Google Trends)"
label variable clemson_interest "Clemson University Interest (Google Trends)"

* 8. Label the dataset.
label data "Google Trends search interest for three universities, 2004-2026. Normalized to peak interest."

* 9. Declare it as time-series data. tsline in step 15 needs this.
*    Check: "time variable: month_date, 2004m1 to 2026m8", "delta: 1 month"
tsset month_date, monthly

* compress shrinks storage types where it safely can. Optional, free.
compress

* 10. Save. The two things people forget: QUOTES around a path containing a
*     space, and , replace so it does not fail the second time you run it.
save "uni_trends.dta", replace


***** ANALYZE

* 11. The wildcard catches all three interest variables at once.
correlate *_interest

* 12. Regress with robust standard errors.
regress nd_interest clemson_interest, robust


***** VISUALIZE

* 13. A plain scatter.
scatter nd_interest clemson_interest

* 14. The same, with a fitted line. twoway takes each piece in parentheses
*     and layers them. legend(pos(6)) puts the legend at the bottom.
twoway (scatter nd_interest clemson_interest) ///
	(lfit nd_interest clemson_interest), ///
	legend(pos(6))

* 15. The same plot for a different school. Barely changed from step 13.
scatter nd_interest mit_interest

* 16. Both comparisons on one graph - two scatters layered.
*     Without legend(order(...)) Stata labels both series "nd_interest",
*     which tells the reader nothing. Name them yourself.
twoway (scatter nd_interest clemson_interest) ///
	(scatter nd_interest mit_interest), ///
	legend(order(1 "Clemson" 2 "MIT")) ///
	xtitle("Other University Interest")

* 17. All three schools over time. This is the one that needed tsset.
tsline nd_interest clemson_interest mit_interest, legend(rows(3))


***** PROVIDED - read these, run them, take them apart

* Built one option at a time from what you typed in 13-17. Delete an option
* and rerun to see what it was doing.

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

* 18. Export it. Doing this straight after drawing is the safe habit: in a
*     batch run, graph export can only reach the graph that is currently
*     displayed. Interactively each named graph has its own window, so you
*     can export any of them at any time.
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

graph export "seasons_tsline.png", replace


***** REPORT

* optional
* 19. Both figures in one image.
graph combine trends_scatter seasons_tsline, name(combo_trends, replace)
graph export "combo_trends.png", replace
