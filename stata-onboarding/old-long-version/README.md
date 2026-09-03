# Getting Started with Stata

**Workshop 1 — Stata Onboarding / Working with Data · 75 minutes**

No statistics background assumed. No prior Stata assumed.

---

## Before the session

1. **Download this folder** from **[github.com/cassandramerritt/ndpop-stata-workshops](https://github.com/cassandramerritt/ndpop-stata-workshops)**
   (green **Code** button → **Download ZIP**) and unzip it somewhere you can find again.
2. **Stata is already installed** on the workshop machines. If you're on your own device, make
   sure it's installed beforehand.

---

## Start here

### ▶ `first_looks.dta` — double-click this

**That's how you open Stata today.** Opening the data opens the program, with the data already
loaded. No path to type, nothing to configure. Your first command is `browse`.

Double-clicking a file also quietly tells Stata which folder to work in — which is a thing worth
knowing about, and section 2.9 of the worksheet is where we look at it properly.

If Stata ever comes back with **`file not found`, `r(601)`**, it is looking in the wrong folder.
Section 2.9 of the worksheet is where we fix that, with `cd` — open the folder in File Explorer,
copy the path from the address bar, and type `cd "` then paste.

### 📄 `handout_stata_onboarding.pdf` — the worksheet

**This is the one to have in front of you during the session.** It tells you what to do at each
step and asks you questions. It does not answer them.

---

## How the worksheet works

**The three blocks hand you less and less, on purpose.**

| | What you get | What you write |
|---|---|---|
| **Block 2** | The commands, printed in full | Nothing — you type them |
| **Block 3** | The task, and the command name in brackets | The syntax |
| **Block 4** | The task, and the *help file* to read | The command |

By Block 4 you're doing what you'll actually be doing afterwards: looking something up.

**Boxes with a bar down the side say _Advanced — not for today_.** Real, working code, printed so
you have it, with no task attached. Run them after the session — every one of them is also in
`block2.do` or `block3.do`.

---

## Block 4 is yours to take home

We don't work through Block 4 in the room. You'll see the figure at the end of the session;
`block4.do` is the file that makes it.

It's written to be followed **on your own, from cold** — nothing in it depends on anything you did
during the workshop. It takes a genuinely raw file (a Google Trends export: search interest for
Notre Dame, MIT and Clemson, monthly, 2004–2026) and carries it all the way to a figure you could
put in a paper. Every command is written out, and most carry the help file behind it.

That makes the shared-machine warning below matter more than usual. Take the folder with you.

---

## Everything in this folder

| File | What it is | When |
|---|---|---|
| `handout_stata_onboarding.pdf` | **Worksheet** — what to do at each step | During |
| `slides_stata_onboarding.pdf` | The slides, for reference | After |
| `first_looks.dta` | **Double-click this to start.** Data for Blocks 2–3 — working out what it is, is the first task | First |
| `google_trends_universities.csv` | Raw data for Block 4 | Block 4 |
| `block2.do` | Block 2 written down — the command-window session | If you fell behind |
| `block3.do` | Block 3 — run it a line at a time | During |
| `block4.do` | **Block 4 — the take-home. Start here afterwards.** | After |

One file per block, and every command in it is written out. The worksheet tells you which lines to
run and what to look for; the file carries the code. The real Block 2 exercise is still building
your **own** version of `block2.do`, out of Stata's History window, at the end of the block.

---

## If you ran out of time

Open the file for that block and run it a line at a time (**Ctrl-D** on Windows, **Cmd-Shift-D** on
Mac), reading what each line does. That is a perfectly good way to learn this.

**One deliberate exception.** In `block3.do`, section 3.3 runs an `assert` that is *meant* to fail,
and it stops the file dead. That halt is the lesson — a summary table you skim past is easy to
ignore, a file that refuses to continue is not. Work out why before you run the line below it.

`block2.do` has four lines commented out for a different reason: `browse`, `bro`, `doedit` and `cls`
only exist in the Stata window, so they can't run from a file. Type those yourself.

---

## Where to get help

- **ND Pop Stata Helpdesk** — drop in, no appointment. **Mon–Thu 5–7pm, 4020D Jenkins Nanovic
  Halls.** Bring your laptop.
  → [populationanalytics.nd.edu/resources/stata-support-services](https://populationanalytics.nd.edu/resources/stata-support-services/)
- **Navari Family Center for Digital Scholarship** — Hesburgh Library, 2nd floor NE corner.
  Consultations on data analysis, visualisation, GIS, text mining → cds@nd.edu

**Stuck, in order:** `help commandname` → `search keyword` → the internet (paste the exact error,
`r(###)` included) → a person.

**AI chatbots** are useful for finding a command name or decoding an error — but they invent
options that don't exist, fluently. **Never run a Stata command from a chatbot until you understand
it independently.**

---

## Working on a shared machine?

**Anything you save to a lab computer may be gone when you log out.**

The files in this folder are safe — you can download them again any time. **The files you write
today are not.** Before you leave, copy your work to a USB stick, your email, or a cloud drive.

---

## What's next

**Workshop 2 — Data Wrangling.** Collapse, append, merge, reshape: building the dataset an analysis
actually needs, out of the files you were handed. It's built on the question this session keeps
asking — *what is one row?*
