* =====================================================================
*  Block 2 - First Look at Stata
*  The command-window session, written down.
*
*  Opens:  first_looks.dta   50 obs, 16 vars  (one row per state, 1980)
*  Saves:  nothing. Block 2 changes no data.
*
*  Block 2 is done in the Command window, not in a do-file, so there is
*  no "student" version of this file - the handout prints every command
*  in full. This is the record: what you ran, in order, and what it
*  showed you. Use it to catch up, or to review afterwards.
*
*  At the end of Block 2 you build your OWN version of this file, out of
*  Stata's History window. That one is the real exercise. This one is
*  the fallback.
*
*  FIVE LINES ARE COMMENTED OUT. browse, bro, Browse, doedit and cls
*  only exist in the Stata window. Run this file in batch and they
*  return "command ... is unrecognized", r(199). Type them yourself in
*  the Command window, where they work.
* =====================================================================

clear all
set more off

capture confirm file "first_looks.dta"
if _rc {
	capture cd ..
	confirm file "first_looks.dta"
}


* ---------------------------------------------------------------------
*  2.1  Open it
* ---------------------------------------------------------------------
* In the session you did not type this: you double-clicked
* first_looks.dta, which opens Stata with the data already loaded. This
* file has to run on its own, so it opens the data itself.
use "first_looks.dta", clear

* browse
* ^ Opens the data in a spreadsheet view. Read-only - look, do not edit.
*   Close that window to get back to the Command window.

* What IS this data? What does one row represent? What does a column?
* Answer from the screen before anyone tells you. Hold onto the row
* question - it comes back in Block 4, and Workshop 2 is built on it.


* ---------------------------------------------------------------------
*  2.2  Two small experiments
* ---------------------------------------------------------------------
* Browse
* ^ "command Browse is unrecognized", r(199). Stata is case-sensitive.
* bro
* ^ Works. Most commands have a legal short form.
*
* Two lessons: capitals matter, and abbreviations are allowed. The
* second one is convenient to type and unkind to whoever reads it later,
* including you.
*
* You have also now seen what an error looks like. Errors are normal.
* Read them.


* ---------------------------------------------------------------------
*  2.3  The windows
* ---------------------------------------------------------------------
* Nothing to type. Results, Command, History, Variables, Properties, and
* the drop-down menus. Use a menu with the Results window in view: Stata
* writes the command it just ran. That is how you find a command name
* you were about to go searching for.


* ---------------------------------------------------------------------
*  2.4  Describing, and the shape of a command
* ---------------------------------------------------------------------
* Run these one at a time and watch what changes.
describe
describe state
describe state pop
describe state pop-popurban
describe state pop*
describe state pop??p

* The shape of every Stata command, induced from those six:
*     command  varlist  , options
* pop-popurban is a RANGE through the dataset's own order, not
* alphabetical. pop* is a wildcard. pop??p matches one character per ?.

* Three ways of looking at the same variables.
codebook state pop has_nd
inspect state pop has_nd
summarize state pop has_nd

* summarize gives state zero observations. It is text, and there is no
* mean of a word.


* ---------------------------------------------------------------------
*  2.5  Listing rows, and if
* ---------------------------------------------------------------------
list state has_nd
list state has_nd if has_nd == 1

* Indiana, and only Indiana. == asks a question, = assigns a value.
* They are not interchangeable.

* PREDICT FIRST. Write down what you think each of the next two returns
* before you run them.
list state has_nd if has_nd != 0
list state has_nd if has_nd > 0

* Both return California AND Indiana. California's has_nd is MISSING,
* and Stata stores missing as larger than any number - larger than 0,
* than 1, than a billion. So it passes both tests.
*
* This will quietly corrupt real work. The habit that prevents it:
* count if missing(x) BEFORE you filter on x.

help list


* ---------------------------------------------------------------------
*  2.6  Counting
* ---------------------------------------------------------------------
tabulate border
tabulate state border
tabulate border coastal
tabulate border coastal, row column

* 35 / 15 on the first one. The second fills the screen with 50 rows,
* which is itself the lesson about when a cross-tabulation stops being
* useful. The comma introduces options.

count if border == 1 & coastal == 1
list state if border == 1 & coastal == 1


* ---------------------------------------------------------------------
*  2.7  ADVANCED - not for today
*  Row order. See the handout box.
* ---------------------------------------------------------------------
sort pop
gsort pop65p
gsort -pop65p
list state pop65p in 1/5


* ---------------------------------------------------------------------
*  2.8  Your first do-file
* ---------------------------------------------------------------------
* This is the point of the whole block, and it is done by clicking:
*
*   1. History window -> the stop-sign icon -> Copy All
*   2. doedit          (opens an empty do-file editor)
*   3. Paste
*   4. Save it as first_do.do
*   5. do first_do.do
*
* You have just turned an hour of typing into something you can run
* again. If someone handed you that file tomorrow, could they follow it?
* What is missing from it? Comments - which is exactly what Block 3
* opens with.
*
* doedit
* do first_do.do
* cls
* ^ All three are window commands, r(199) in batch. Type them yourself.

clear all

display _n "Block 2 complete. Nothing was saved - Block 2 changes no data."
