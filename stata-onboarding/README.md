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

### ▶ `start_here.do` — double-click this

Stata opens with its working directory already set to this folder, which is where the data is. Run
the two lines inside it (`pwd` and `dir`) to confirm. That's the entire setup — you won't type a
file path again all session.

If `pwd` shows the wrong folder, Stata was already open and kept its old working directory.
`start_here.do` explains how to fix that with `cd`. Use **forward slashes, even on Windows** — they
work on Windows and Mac both, and Windows hands you backslashes when you paste, so change them.

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
`block2_complete.do` or `block3_complete.do`.

---

## Block 4 is yours to take home

We don't work through Block 4 in the room. You'll see the figure at the end of the session;
`block4_student.do` is the file that makes it.

It's written to be followed **on your own, from cold** — nothing in it depends on anything you did
during the workshop. It takes a genuinely raw file (a Google Trends export: search interest for
Notre Dame, MIT and Clemson, monthly, 2004–2026) and carries it all the way to a figure you could
put in a paper. `block4_complete.do` has every answer, commented.

That makes the shared-machine warning below matter more than usual. Take the folder with you.

---

## Everything in this folder

| File | What it is | When |
|---|---|---|
| `start_here.do` | Opens Stata in the right folder | First |
| `handout_stata_onboarding.pdf` | **Worksheet** — what to do at each step | During |
| `slides_stata_onboarding.pdf` | The slides, for reference | After |
| `first_looks.dta` | Data for Blocks 2–3 — working out what it is, is the first task | Blocks 2–3 |
| `google_trends_universities.csv` | Raw data for Block 4 | Block 4 |
| `block2_complete.do` | Block 2 written down — the command-window session | If you fell behind |
| `block3_student.do` | Block 3 — you fill it in | During |
| `block3_complete.do` | Block 3 **with every answer filled in** | After |
| `block4_student.do` | **Block 4 — the take-home. Start here afterwards.** | After |
| `block4_complete.do` | Block 4 **with every answer filled in** | After |

There's no `block2_student.do`, because the worksheet prints every Block 2 command in full — the
worksheet *is* the student version. `block2_complete.do` is the fallback record, for catching up or
reviewing. The real Block 2 exercise is building your **own** version of it, out of Stata's History
window, at the end of the block.

---

## If you ran out of time

Both `_complete.do` files run start to finish. Open one, run it a line at a time (**Ctrl-D** on
Windows, **Cmd-Shift-D** on Mac), and read what each line does. That is a perfectly good way to
learn this.

One deliberate exception: in `block3_complete.do` an `assert` that is *meant* to fail is commented
out, with its exact error written above it — otherwise it would stop the file and you'd never reach
the rest. Uncomment it and run it once. Watching it halt is the lesson.

`block2_complete.do` has five lines commented out for a different reason: `browse`, `bro`, `doedit`
and `cls` only exist in the Stata window, so they can't run from a file in batch. Type those
yourself.

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
