# Getting Started with Stata — Worksheet
### Workshop 1 — Stata Onboarding / Working with Data · 75 minutes

**This Sheet** provides guided instructions to help you progress through the workshop.

---

> ## ⚠ Setting up
>
> **0.** If you have Stata already installed, you may use your own device. Otherwise, please use a lab workstation. If you need help with installation, talk to me after the session.
>
> **1.** Go to **[github.com/cassandramerritt/ndpop-stata-workshops](https://github.com/cassandramerritt/ndpop-stata-workshops)**
> → green **Code** button → **Download ZIP**
>
> **2. Unzip the download.** Note: on lab workstations, this will not automatically sync --- they'll stay local, but assume it will not last. 
>
> **3. Lab workstations are shared machines.** Before you leave, copy your work to a USB stick, your email, or a cloud drive.
>

## Marks used below

| Mark | Meaning |
|---|---|
| **▶** | You type it |
| **◉** | Instructor will demonstrate. |
| **◈** | **Stop, think, share.** We will discuss as time allows.  |
| **◇** | Only if we have time. The worked do-files cover it either way. |

---

## Block 1 — Introduction

```
   COLLECT  ──▶  INSPECT ◀──▶ CLEAN  ──▶  ANALYZE  ──▶  REPORT
                     └── loop ──┘
```

| Stage | Today |
|---|---|
| **Inspect** | **Block 2** |
| **Clean** | **Block 3** |
| Analyze · Report | Block 4 |

<div style="page-break-after: always;"></div>

## Block 2 — First Look at Stata

### 2.1 Open it

**▶** Double-click `first_looks.dta` in your file explorer (where you unzipped the downloaded files).

**▶** `browse`

**◈ Before anyone tells you:** How much can you work out from this screen alone? 
**What *is* this data?**
**What is a row (horizontal) of data?**
**What is a column (vertical) of data?**

### 2.2 Two small experiments

**▶** `Browse`  → then → `bro`

**◈ What are the two lessons?** 

### 2.3 The windows

**◉** Results · Command · History · Variables · Properties · drop-down menus

### 2.4 Describing

**▶** Run one at a time. 
```stata
describe
describe state
describe state pop
describe state pop-popurban
describe state pop*
describe state pop??p
```

**◈ What is the general shape of a Stata command?** 

**◉** `describe state pop-state`  ← fails on purpose. Why?

**▶** `codebook state pop has_nd` and `inspect state pop has_nd` do similar jobs.
**◈ When would you reach for one rather than another?**

**▶** `summarize state pop has_nd`

**◈** `state` gets no observations. Why not?

### 2.5 Listing rows, and `if`

**▶**
```stata
list state has_nd
list state has_nd if has_nd == 1
```
→ Indiana, and only Indiana. (`==` asks a question. `=` assigns a value. They are not interchangeable.)

**◈ PREDICT FIRST — what do you think each of the next commands will return, then run them.**

```stata
list state has_nd if has_nd != 0
list state has_nd if has_nd > 0
```

Now run them. **Were you right? If not, what is going on?**

**▶** `help list`

### 2.6 Counting

**▶**
```stata
tabulate border
tabulate state border
tabulate border coastal
tabulate border coastal, row column
```
→ 35 / 15 on the first one.

**◈ What does the comma do?** Add it to your syntax sketch in 2.4.

**▶**
```stata
count if border == 1 & coastal == 1
list state if border == 1 & coastal == 1
```
→ 7 states.

### 2.7 Sorting

**▶** Run one at a time, and watch the row order change.
```stata
sort pop
gsort pop65p
gsort -pop65p
list state pop65p in 1/5
```
**◈** What is the minus sign doing? And how does `in` differ from `if`?

**◇** `gsort region -pop` · `by region: list state pop` · `bysort coastal: list state pop`

### 2.8 Your first do-file

**▶** `pwd`

**◈ Read what it says.** You never told Stata where to work. So why does it have an answer?

**▶/CLICK**
1. **History** window → stop-sign icon → **Copy All**
2. `doedit` → **paste**
3. Save as **`first_do.do`**
4. `do first_do.do`

**◈** If I handed you that file tomorrow, could you follow it? What is missing from it?

**▶** `cls` then `clear all`. Then close Stata and reopen it from the Start Menu — not by
double-clicking the data. **Check `pwd` again.**

<div style="page-break-after: always;"></div>

## Block 3 — Your First Stata Project

*From here you write more of the syntax yourself.*

### 3.1 Working directory

**▶** `pwd`

**▶** Point Stata at your unzipped folder. Forward slashes, keep the quotes.

**▶** `pwd` · `dir`

**◉** `cd .` · `cd ..`

**◈** A path like `first_looks.dta` versus `C:/Users/.../first_looks.dta` — when does each break?

### 3.2 Start a real do-file

**▶** `doedit` → save as `block3.do`. **From here, type into the do-file, not the Command window.**
Run one line with **Ctrl-D** (Win) / **Cmd-Shift-D** (Mac).

Open it with comments — `*` at the start of a line:
```stata
* block3.do
* Cleaning the 1980 Census state data
* your name, today's date
```

### 3.3 Does the data add up?

Population is split by age: `poplt5`, `pop5_17`, `pop18p`, `pop65p`. They should total `pop`.

**▶** Create `check_pop` as those four added together. (`generate`)

**▶** Compare it against `pop`. (the summarizing command from 2.4)

**▶** `assert pop == check_pop`

**◈** This one fails on purpose, and stops the do-file. Why?

**▶** Fix it with `replace` (not `generate` — it already exists), then `assert` again.
→ Silence means it passed.

**▶** Create the mutually exclusive groups: `pop18p` minus `pop65p`. Call it `pop18_65`.

**◈** Is this new variable *name* accurate? If needed, use the (`rename`) command.

**▶** Build `check2_pop` from the four groups that now don't overlap, `assert` it against `pop`,
then `drop` both check variables.

### 3.4 Functions

**▶** Create `pop_m` = `pop` divided by a million. Stata understands math expressions. Then `replace` it, rounded to one decimal —
`round(pop_m, .1)`.

**▶** `help functions`

### 3.5 Stata remembers more than it shows

**▶** `summarize pop, detail`

**▶** `return list`

**◈** What just appeared, and where did it come from?

**▶** `generate big_state = (pop >= r(p90))`

**▶** List the states where `big_state` is 1. → 5 states.

**◇**
```stata
egen big_state2 = pctile(pop), p(90)
replace big_state2 = pop >= big_state2
assert big_state == big_state2
```
**◈** Compare the two. What does that tell you?

### 3.6 Text · ◉

Regular expressions are not something you are expected to write.

```stata
list state state2 if regexm(state, "\.")
generate state3 = substr(state, 4, strlen(state)) if regexm(state, "\.")

replace state = "South" if state2 == "SC" | "SD"       // WRONG (HOW TO FIX?)
replace state = "South" if inlist(state2, "SC", "SD")  // ALTERNATE ANSWER
```
**◈** The wrong line reads like English. Why isn't it valid?

### 3.7 Labels

**▶**
```stata
label data "1980 US Census, State Level"
label variable coastal "On a Coast"

tabulate coastal border
label define yn_dummy 0 "No" 1 "Yes"
label values coastal border yn_dummy
tabulate coastal border
```
**◈** Compare the two `tabulate`s. What changed — and what didn't?

**◇** `label define cenreg 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify` · `tabulate region, nolabel`

### 3.8 Groups · ◇

**▶** `generate nval = _n` · `generate nvals = _N` 

**◈** Inspect the data. What are these new variables?

**▶** `drop nval*`

**▶**
```stata
bysort region: generate region_states = _N
bysort region: generate nval = _n
bysort region: egen region_pop = sum(pop_m)
list region region_states region_pop if nval == 1
```
**◈** Inside `bysort region:`, what does `_N` mean now? And what is `if nval == 1` for?

### 3.9 Log files

**▶**
```stata
capture log close
log using "test_log.txt", text replace
display "This is a test."
display 1 + 1
log close
```
**◈** What is each of `capture`, `, text` and `, replace` protecting you from?

Open `test_log.txt` in a text editor.

<div style="page-break-after: always;"></div>

## Block 4 — First Output from Raw Input

**Work in `block4_student.do`.** It gives you the task at each step; you write the command.

Each task ends with a **`help:`** line naming the help file for every command and function the answer
uses. The **Syntax** block at the top and the **Examples** at the bottom are the parts to read.

**◈** In Block 2, one row was one state. **What is one row here?**

You will: import a CSV → fix the dates → rename and label → `correlate` and `regress` →
`scatter` / `twoway` / `tsline` → `graph export`.

The polished figures are printed complete in the do-file.

---

## Block 5 — Where to go next

**Look up:** macros (`help macro`) · loops (`help foreach`) · `ssc install`

**Stuck, in order:** `help commandname` → `search keyword` → the internet (paste the exact error,
`r(###)` included) → a person.

**People who will help you:**

- **ND Pop Stata Helpdesk** — drop in, no appointment. **Mon–Thu 5–7pm, 4020D Jenkins Nanovic Halls.**
  Bring your laptop. → [populationanalytics.nd.edu/resources/stata-support-services](https://populationanalytics.nd.edu/resources/stata-support-services/)
- **Navari Family Center for Digital Scholarship** — Hesburgh Library, 2nd floor NE corner.
  Consultations on data analysis, visualisation, GIS, text mining → cds@nd.edu

**Online:**

- The `help` command. Full Stata manuals are included in the installation.
- [stata.com/support](https://www.stata.com/support/) — FAQs and video tutorials
- [blog.stata.com](https://blog.stata.com) — detailed worked examples
- [stats.oarc.ucla.edu/stata](https://stats.oarc.ucla.edu/stata/) — UCLA OARC tutorials and annotated output
- **[Stata cheat sheets](https://www.stata.com/flyers/stata-cheat-sheets/)** — free PDFs, including one for syntax


**AI chatbots:** useful for finding a command name or decoding an error — but they invent options
that don't exist or are poor answers, fluently. **Never trust a Stata command from a chatbot until you have understand it independently.**

**An Advanced Textbook with Stata:** Cameron & Trivedi, *Microeconometrics Using Stata*, 2nd ed. (Stata Press, 2022)
— a graduate text, well beyond today. Its early chapters on syntax and data management cover the
ground you started here; check the library.

**Before you log out:** copy your do-files off this machine.

---

## Afterwards

| File | What it is |
|---|---|
| `block3_complete.do`, `block4_complete.do` | Working do-files with all the answers filled in |
| `first_looks.dta`, `google_trends_universities.csv` | The data |

All on **[github.com/cassandramerritt/ndpop-stata-workshops](https://github.com/cassandramerritt/ndpop-stata-workshops)** permanently.
Your own do-files are not — save those yourself.
