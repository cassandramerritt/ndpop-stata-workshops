* =====================================================================
*  DO NOT START HERE.
*
*  To start: double-click first_looks.dta. Opening the data is how you
*  open Stata today. There is no path to type and nothing to configure.
*
*  This file is the rescue hatch, for one situation only: Stata is
*  looking in the wrong folder. You will know because a command that
*  names a file - use, save, log using, import delimited - comes back
*  with "file not found", r(601).
*
*  Section 2.9 of the worksheet does this properly, as a lesson. This is
*  the written version, for when you need it in a hurry.
* =====================================================================


* --- 1. Where does Stata think it is? ---------------------------------
* Highlight the line and press Ctrl-D (Windows) or Cmd-Shift-D (Mac).

pwd


* --- 2. Can it see the data? ------------------------------------------
* This should list first_looks.dta and google_trends_universities.csv.

dir


* =====================================================================
*  If pwd printed the wrong folder
*
*  Two ways that happens. Either Stata was ALREADY OPEN when you
*  double-clicked, so the file went to the running Stata and it kept
*  whatever folder it already had. Or you started Stata from the Start
*  menu or Spotlight, in which case nothing ever chose a folder for you.
*
*  Either way, say where to look. The reliable way to get the path right:
*    1. Open the workshop folder in File Explorer or Finder.
*    2. Click the address bar. The path becomes selectable text.
*    3. Copy it.
*    4. Type  cd "  then paste, then close the quote.
*
*  It will look something like this:
*
*  cd "C:/Users/nd_netid/Downloads/stata-onboarding"
*
*  Use FORWARD slashes, even on Windows. They work on Windows and Mac
*  both. Windows will hand you backslashes when you paste - change them.
*
*  Then run pwd and dir again.
* =====================================================================
