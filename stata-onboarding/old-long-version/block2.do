* block2.do - Block 2 at the Command window, written down
* run it to catch up or to review. nothing here is saved

* in the room you double-clicked first_looks.dta instead of typing this
use "first_looks.dta", clear


*** 2.1 Open It

* GUI only, so it cannot run from a file. opens a read-only view
// browse


*** 2.3 Two Small Experiments

* also GUI only. the first is an error, the second works
// Browse
// bro


*** 2.4 Describing, and the Shape of a Command

* the whole dataset, then one variable
describe
describe pop

* a range in dataset order, a wildcard, and one character per ?
describe pop-popurban
describe pop*
describe pop??p

* three ways of looking at the same two variables
codebook pop has_nd
inspect pop has_nd
summarize pop has_nd


*** 2.5 Listing Rows, and if

* == asks a question. = assigns a value
list state has_nd
list state has_nd if has_nd == 1

* WRITE DOWN what you think each of these returns, then run them
list state has_nd if has_nd != 0
list state has_nd if has_nd > 0

* both return California AND Indiana. why?

* the options for any command are in its help file
help list


*** 2.6 Counting

* one variable, then 50 rows of one, then two variables crossed
tabulate border
tabulate state border
tabulate border coastal

* everything after the comma is an option
tabulate border coastal, row column

* how many, and which ones
count if border == 1 & coastal == 1
list state if border == 1 & coastal == 1


*** 2.7 ADVANCED - not for today

* sort goes up only. gsort takes a minus sign to go down
sort pop
gsort pop65p
gsort -pop65p

* in filters by position, if by value
list state pop65p in 1/5


*** 2.8 Your First Do-File

* all clicking, no commands. History -> the circular warning icon ->
* Copy All -> doedit -> paste -> save as first_do.do -> do first_do.do


*** 2.9 Where Has Stata Been Working?

* clears the Results window. GUI only
// cls

* you never told Stata where to work. so why does it have an answer?
pwd

* wipe the data and start clean
clear all
