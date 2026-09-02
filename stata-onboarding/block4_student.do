*** =====================================================================
***  Block 4 - First Output from Raw Input
***  Google Trends search interest: Notre Dame, MIT, Clemson.
***
***  THIS IS THE TAKE-HOME BLOCK. We do not work through it in the room;
***  you saw the figure at the end of the session, and this is the file
***  that makes it. It is written to be followed on your own, from cold.
***  Nothing here depends on anything you did during the workshop.
***
***  THE DATA. google_trends_universities.csv sits in this same folder -
***  the one you downloaded and unzipped. It is a raw export, the kind
***  you actually get handed: 272 monthly rows, January 2004 to August
***  2026, three columns of search interest.
***
***  The numbers are RELATIVE. Google scales them so that the single
***  highest point across all three search terms is 100. Nothing here
***  counts people.
***
***  HOW TO USE THIS FILE. You write the commands. Each task says what
***  to do, not how. Every task ends with a "help:" line naming the help
***  file for each command or function the answer uses - open them. That
***  is the actual skill: nobody memorises Stata, they know what to look
***  up. Read the SYNTAX block at the top of a help file and the EXAMPLES
***  at the bottom; the middle is reference you can skip until you need
***  it.
***
***  Run the highlighted line(s) with Ctrl-D (Windows) / Cmd-Shift-D
***  (Mac). Stuck? block4_complete.do has every answer, commented.
*** =====================================================================

clear all
set more off

* Find the data whether you are in the workshop folder already or one
* level down inside it. If this errors, the CSV is not where this file
* is - put them in the same folder.
capture confirm file "google_trends_universities.csv"
if _rc {
	capture cd ..
	confirm file "google_trends_universities.csv"
}


***** IMPORT

* 1. Import google_trends_universities.csv.
*    The command is not "use" - that is for .dta files. This is a CSV.
*    Check: 272 observations, 4 variables
*    help: import delimited



* 2. Look at what arrived. Three commands from Block 2: one for
*    structure, one to see the rows, one for summary statistics.
*    help: describe   summarize



*    What is one row of this dataset? In Block 2 it was one state. Not
*    here. Hold onto that question - it is what Workshop 2 is built on.
*
*    And notice what inspection does NOT tell you. You can read the
*    SHAPE of a dataset off the screen. You cannot read its MEANING -
*    that the numbers are relative, that nothing here counts people.


***** CLEAN

* 3. The time column came in as TEXT, not a date. Stata cannot sort it,
*    plot it, or do arithmetic on it until you convert it. Build a real
*    Stata date from it, then format it so it displays properly.
*    You need two commands.
*    Check: it reads 01jan2004, not 16071
*    help: datetime   format



* 4. The data is monthly, so a daily date is more precision than you
*    want. Make a monthly version and format that too.
*    help: datetime   format



* 5. Put time and your new date variables at the front of the dataset.
*    help: order



* 6. Rename the three interest variables to something you can type.
*    Look at what describe gave you - one of them is
*    massachusettsinstituteoftechnolo, truncated by the import, because
*    Stata variable names stop at 32 characters.
*    You can rename all three in one command.
*    Suggested names: nd_interest, mit_interest, clemson_interest
*    help: rename group



* 7. Label the three variables so the graphs come out readable later.
*    help: label



* 8. Label the dataset as a whole.
*    help: label



* 9. Tell Stata this is time-series data, indexed by your monthly
*    variable. Without this, tsline in step 17 will not work.
*    Check: "time variable: month_date, 2004m1 to 2026m8", "delta: 1 month"
*    help: tsset



* 10. Save your cleaned data. Two things people forget here: the path
*     needs QUOTES if it contains a space, and you need , replace or it
*     fails the second time you run the file.
*     help: save



***** ANALYZE

* 11. Correlate the three interest variables.
*     You can name all three at once with a wildcard.
*     help: correlate



* 12. Regress Notre Dame interest on Clemson interest, with robust
*     standard errors.
*     help: regress   vce_option



*     Two lines, and a semester of knowing when they are the right two.
*     Which two, and what they entitle you to say, is a different course.


***** VISUALIZE

* 13. A scatter of Notre Dame interest against Clemson interest.
*     help: scatter



* 14. The same scatter with a fitted line through it. This needs twoway
*     with two pieces in parentheses. Put the legend at the bottom with
*     legend(pos(6)).
*     help: graph twoway   twoway lfit   legend_options



* 15. Now the same plot for a different school: Notre Dame against MIT.
*     One command, barely changed from step 13.
*     help: scatter



* 16. Put both comparisons on ONE graph - two scatters layered together.
*     twoway again, but this time both pieces are scatters. Stata will
*     label them "nd_interest" twice, which is useless, so name them
*     yourself with legend(order(1 "Clemson" 2 "MIT")). Give the x axis
*     a title that covers both: xtitle("Other University Interest").
*     help: graph twoway   legend_options



* 17. All three schools over time, as lines. This is the one that needs
*     the tsset from step 9. Stack the legend with legend(rows(3)).
*     help: tsline   legend_options



***** PROVIDED - read these, run them, take them apart

* Nobody writes a graph this long from memory. They get built one option
* at a time, starting from what you just typed in steps 13-17. Run them,
* then delete an option and see what changes.

twoway (scatter nd_interest clemson_interest, mcolor(orange)) ///
	(scatter nd_interest mit_interest, mcolor(cranberry)) ///
	(lfit nd_interest clemson_interest, lcolor(orange)) ///
	(lfit nd_interest mit_interest, lcolor(cranberry)), ///
	legend(pos(6) order(1 "Clemson" 2 "MIT")) ///
	ytitle("Notre Dame Interest") ///
	xtitle("Other University Interest") ///
	name(trends_scatter, replace)

* /// at the end of a line means "this command continues on the next
* line". Without it Stata reads each line as a separate command.


* 18. Export that figure as a PNG. Quote the filename, use , replace.
*     Do it straight after drawing - that is the safe habit, because in
*     a batch run graph export can only reach the graph currently
*     displayed.
*     Check: a .png appears in your folder
*     help: graph export



* The last eight years only, with a marker on every September.
* Watch what happens each fall.

tsline nd_interest clemson_interest mit_interest in 170/272, ///
	legend(order(1 "Notre Dame" 2 "Clemson" 3 "MIT") rows(3)) ///
	lcolor(navy cranberry orange) ///
	tline(2018m9 2019m9 2020m9 2021m9 2022m9 2023m9 2024m9 2025m9) ///
	ttext(90 2018m7 "Sept" 90 2019m7 "Sept" 90 2020m7 "Sept" 90 2021m7 ///
	"Sept" 90 2022m7 "Sept" 90 2023m7 "Sept" 90 2024m7 "Sept" 90 2025m7 "Sept", ///
	orient(vert)) ///
	name(seasons_tsline, replace)

* in 170/272 filters by row position, not by date. 272 is the last row.
* Every September the Notre Dame line jumps. Football season.


***** REPORT

* 19. Export that one too, then put both figures in one image and export
*     that as well.
*     help: graph export   graph combine



