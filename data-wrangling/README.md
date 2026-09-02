# Data Wrangling with Stata

**Workshop 2 — Shaping data for analysis · 75 minutes**

Five operations: **collapse, append, merge, reshape**. No statistics, no estimation — just
getting data into the shape an analysis needs.

---

## Before the session

1. **Download this folder** from **[github.com/cassandramerritt/ndpop-stata-workshops](https://github.com/cassandramerritt/ndpop-stata-workshops)**
   (green **Code** button → **Download ZIP**) and unzip it somewhere you can find again.
2. **Stata is already installed** on the workshop machines. If you're on your own device, make
   sure it's installed beforehand.

---

## Start here

### ▶ `start_here.do` — double-click this

Stata opens with its working directory already set to this folder, which is where all the data
is. Run the two lines inside it (`pwd` and `dir *.dta`) to confirm. That's the entire setup —
you won't type a file path again all session.

If `pwd` shows the wrong folder, Stata was already open and kept its old working directory.
`start_here.do` explains how to fix that with `cd`.

### 📄 `handout_data_wrangling.pdf` — the worksheet

**This is the one to have in front of you during the session.** It gives the shape of each
command with slots to fill in, and tells you what to expect when it works. It does not fill
them in for you.

---

## Two kinds of file name

This matters, and it's the only convention to remember.

| | Named like | Meaning |
|---|---|---|
| **Files given to you** | `block1_1980`, `block3a`, `block4` | The number tells you which block to open it for |
| **Files you make** | `state_1980`, `state_race`, `state_wide` | Named for what's in them |

Because the two never share a name, your work can never overwrite the file you might need to
fall back on.

---

## If a block doesn't work out

**Open the next block's file and carry on.** That's exactly what they're for, and you won't be
behind. Every block on the handout ends with `describe` and the number of observations and
variables you should see, so you can check yourself without asking.

If in any doubt, open the provided file.

---

## Everything in this folder

| File | What it is | When |
|---|---|---|
| `start_here.do` | Opens Stata in the right folder | First |
| `handout_data_wrangling.pdf` | **Worksheet** — what to do at each step | During |
| `slides_data_wrangling.pdf` | The slides, for reference | After |
| `takehome_data_wrangling.do` | **The whole session with every command filled in** | After |
| `solutions/` | One do-file per block, each standing alone | During or after |
| `block1_*.dta` | County-level data, race/ethnicity — Block 1 | Block 1 |
| `block2_*.dta` | State-level data, one file per year — Block 2 | Block 2 |
| `block3a.dta`, `block3b.dta` | Race/ethnicity and age groups, to be joined — Block 3 | Block 3 |
| `block4.dta` | The merged state-year panel — Block 4 | Block 4 |
| `block5.dta` | The same panel, wide by decade — Block 5 | Block 5 |
| `block3b_*.dta`, `xwalk_statefip_region.dta` | For the optional explorations in Block 3 | If time |

---

## Afterwards

`takehome_data_wrangling.do` runs start to finish with every command written out and commented,
including the things the session only mentioned in passing — merge direction, what `update` and
`update replace` really do, and why keys have to match in *type* and not just in value.

The `solutions/` folder has the same material split one file per block. Each one opens its own
data and stands alone, so you can run just the block you want.

One deliberate exception in both: a `reshape` command that is **meant** to fail, wrapped so it
doesn't stop the file. Run it and read the error — the asymmetry it exposes is the lesson.

---

## About the data

Three IPUMS USA samples — 1980, 1990, 2000 — of different people each time. That makes it a
**repeated cross-section**, not a panel: nobody appears twice, so you can't follow a person
across decades. But every *state* appears in all three rounds, which is why aggregating to the
state is the first thing we do.

Population counts are already weighted estimates; the survey weight was applied when the files
were built, so there's no weight for you to add.

---

## Working on a shared machine?

**Anything you save to a lab computer may be gone when you log out.**

The files in this folder are safe — you can download them again any time. **The files you write
today are not.** Before you leave, copy your work to a USB stick, your email, or a cloud drive.
