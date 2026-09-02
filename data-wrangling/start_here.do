* =====================================================================
*  Data Wrangling with Stata - START HERE
*
*  Double-click this file. Stata opens with its working directory
*  already set to this folder, which is where all the workshop data
*  lives. That is the whole setup.
*
*  Run the two lines at the bottom to confirm it worked.
* =====================================================================


***** 1. Where am I
* This should print the folder this file is sitting in.

pwd


***** 2. Can I see the data?
* This should list 14 .dta files.

dir *.dta


* =====================================================================
*  If pwd printed the wrong folder
*
*  That happens when Stata was ALREADY OPEN before you double-clicked:
*  the file gets handed to the running Stata, which keeps whatever
*  working directory it already had.
*
*  Fix it with cd. The reliable way to get the path right:
*    1. Open this folder in File Explorer.
*    2. Click the address bar. The path becomes selectable text.
*    3. Copy it.
*    4. Type  cd "  then paste, then close the quote.
*
*  It will look something like this:
*
*  cd "C:\Users\<netid>\Downloads\data-wrangling"
*
*  Then run pwd and dir *.dta again.
*
*  YOU CAN DELETE THIS COMMENT BLOCK WHEN YOU ARE DONE WITH IT
* =====================================================================
