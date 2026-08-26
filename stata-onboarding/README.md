# Getting Started with Stata

**Workshop 1 — Stata Onboarding / Working with Data · 75 minutes**

No statistics background assumed. No prior Stata assumed.

---

## Before the session

1. **Download this folder** from **[github.com/cassandramerritt/ndpop-stata-workshops](https://github.com/cassandramerritt/ndpop-stata-workshops)**
   (green **Code** button → **Download ZIP**) and unzip it somewhere you can find again.
   It's recommended to move it to a stable folder on your device. Ideally a cloud-synced folder. 
2. **Stata is already installed** on the workshop machines. Nothing to set up. If you are using your own device, please make sure it's installed beforehand.

---

## Start here

### 📄 `handout_stata_onboarding.md` — the worksheet

**This is the one to have open during the session.** It tells you what to do at each step and asks
you questions. It does not answer them.

### 📗 `block3_complete.do` and `block4_complete.do` — the worked do-files

**For afterwards.** Every command filled in, with comments explaining what each one does. Run them a
line at a time to review, or to catch up on anything the session did not reach.

---

## Everything in this folder

| File | What it is | When |
|---|---|---|
| `handout_stata_onboarding.md` | **Worksheet** — what to do, and questions to think about | During |
| `first_looks.dta` | Data for Blocks 2–3 — working out what it is, is the first task | Blocks 2–3 |
| `google_trends_universities.csv` | Raw data for Block 4 | Block 4 |
| `block3_student.do` | Block 3 do-file — you fill it in | During |
| `block4_student.do` | Block 4 do-file — you fill it in | During |
| `block3_complete.do` | Block 3 **with every answer filled in** | After |
| `block4_complete.do` | Block 4 **with every answer filled in** | After |

---

## If you ran out of time

Both `_complete.do` files run start to finish. Open one, run it a line at a time
(**Ctrl-D** on Windows, **Cmd-Shift-D** on Mac), and read what each line does. That is a perfectly
good way to learn this.

One deliberate exception: in `block3_complete.do` an `assert` that is *meant* to fail is commented
out, with its exact error written above it — otherwise it would stop the file and you would never
reach the rest. Uncomment it and run it once. Watching it halt is the lesson.

---

## Working on a shared machine?

**Anything you save to a lab computer may be gone when you log out.**

The files in this folder are safe — you can download them again any time. **The files you write
today are not.** Before you leave, copy your do-files to a USB stick, your email, or a cloud drive.
