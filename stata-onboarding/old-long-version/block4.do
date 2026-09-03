* block4.do - Google Trends search interest: Notre Dame, MIT, Clemson
* the take-home block. saves uni_trends.dta and three PNGs

* the CSV sits in the same folder as this file
capture confirm file "google_trends_universities.csv"
if _rc cd ..


*** 4.1 Import and Inspect

* not use - that is for .dta files. this is a CSV
* help: import delimited
import delimited using "google_trends_universities.csv", clear

* look at what arrived: the structure, the rows, the summary statistics
* help: describe   summarize
describe
list in 1/5
summarize

* 272 rows, 4 columns. one row is one MONTH - in Block 2 it was one state
* the numbers are relative, not counts. nothing here counts people


*** 4.2 Dates

* time arrived as text. build a real date from it, then format it
* help: datetime   format
generate date = date(time, "YMD")
format date %td

* 16071 is days since 1jan1960. dates are numbers wearing a costume

* the data is monthly, so a daily date is more precision than you want
* help: datetime   format
generate month_date = mofd(date)
format month_date %tm

* put the date variables at the front where you can see them
* help: order
order time date


*** 4.3 Rename, Label, Save

* describe showed massachusettsinstituteoftechnolo - names stop at 32
* help: rename group
rename (universityofnotredame massachusettsinstituteoftechnolo clemsonuniversity) ///
	(nd_interest mit_interest clemson_interest)

* label the variables, so the graphs come out readable
* help: label
label variable nd_interest "University of Notre Dame Interest (Google Trends)"
label variable mit_interest "Massachusetts Institute of Technology Interest (Google Trends)"
label variable clemson_interest "Clemson University Interest (Google Trends)"
label data "Google Trends search interest for three universities, 2004-2026. Normalized to peak interest."

* declare it a time series, or tsline below will not draw
* help: tsset
tsset month_date, monthly

* quotes if the path has a space, and , replace to run the file twice
* help: save
save "uni_trends.dta", replace


*** 4.4 Analyze

* the wildcard names all three interest variables at once
* help: correlate
correlate *_interest

* robust changes how the standard errors are worked out
* help: regress   vce_option
regress nd_interest clemson_interest, robust

* two lines. which two, and what they let you say, is a different course


*** 4.5 Visualize

* the plain version first
* help: scatter
scatter nd_interest clemson_interest

* twoway layers pieces in parentheses. legend(pos(6)) puts it below
* help: graph twoway   twoway lfit   legend_options
twoway (scatter nd_interest clemson_interest) ///
	(lfit nd_interest clemson_interest), ///
	legend(pos(6))

* the same plot, different school. one small change
* help: scatter
scatter nd_interest mit_interest

* both comparisons on one graph, named so the legend is not useless
* help: graph twoway   legend_options
twoway (scatter nd_interest clemson_interest) ///
	(scatter nd_interest mit_interest), ///
	legend(order(1 "Clemson" 2 "MIT")) ///
	xtitle("Other University Interest")

* all three over time. this is the one that needed the tsset
* help: tsline   legend_options
tsline nd_interest clemson_interest mit_interest, legend(rows(3))


*** 4.6 The Polished Versions

* built one option at a time from what you just ran. delete an option
* and rerun to see what it was doing. three slashes at the end of a line
* mean the command carries on below
twoway (scatter nd_interest clemson_interest, mcolor(orange)) ///
	(scatter nd_interest mit_interest, mcolor(cranberry)) ///
	(lfit nd_interest clemson_interest, lcolor(orange)) ///
	(lfit nd_interest mit_interest, lcolor(cranberry)), ///
	legend(pos(6) order(1 "Clemson" 2 "MIT")) ///
	ytitle("Notre Dame Interest") ///
	xtitle("Other University Interest") ///
	name(trends_scatter, replace)

* export straight after drawing. that habit keeps working in batch
* help: graph export
graph export "trends_scatter.png", replace

* the last eight years, with a marker on every September
tsline nd_interest clemson_interest mit_interest in 170/272, ///
	legend(order(1 "Notre Dame" 2 "Clemson" 3 "MIT") rows(3)) ///
	lcolor(navy cranberry orange) ///
	tline(2018m9 2019m9 2020m9 2021m9 2022m9 2023m9 2024m9 2025m9) ///
	ttext(90 2018m7 "Sept" 90 2019m7 "Sept" 90 2020m7 "Sept" 90 2021m7 ///
	"Sept" 90 2022m7 "Sept" 90 2023m7 "Sept" 90 2024m7 "Sept" 90 2025m7 "Sept", ///
	orient(vert)) ///
	name(seasons_tsline, replace)

* in 170/272 filters by row position, not by date
* every September the Notre Dame line jumps. football season

* export that one too
graph export "seasons_tsline.png", replace


*** 4.7 Report

* both figures in one image, exported the same way
* help: graph export   graph combine
graph combine trends_scatter seasons_tsline, name(combo_trends, replace)
graph export "combo_trends.png", replace
