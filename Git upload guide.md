\# Git Upload Guide — Low-Power ALU Verilog



\---



\## STEP 1: Create GitHub Repository



1\. Go to https://github.com

2\. Click "+" → New Repository

3\. Fill:

&#x20;  - Repository name: Low-Power-ALU-Verilog

&#x20;  - Description: 8-bit Parameterized ALU in Verilog | Operand Isolation | RTL Design | Vivado 2024.2

&#x20;  - Visibility: Public

&#x20;  - DO NOT check "Add README" (we already have one)

4\. Click "Create Repository"

5\. Copy the repo URL shown on screen:

&#x20;  https://github.com/your-username/Low-Power-ALU-Verilog.git



\---



\## STEP 2: Install Git (if not installed)



Download: https://git-scm.com/download/win

Install with default settings.



Verify:

&#x20; Open CMD → type: git --version

&#x20; Should show: git version 2.x.x



\---



\## STEP 3: Configure Git (First Time Only)



Open CMD or Git Bash:



&#x20; git config --global user.name "Your Name"

&#x20; git config --global user.email "your@email.com"



\---



\## STEP 4: Open Your Project Folder in CMD



Option A — CMD:

&#x20; cd D:/VLSI/Low-Power-ALU-Verilog



Option B — Right-click the folder → "Open Git Bash here"



\---



\## STEP 5: Initialize Git



&#x20; git init



\---



\## STEP 6: Add Screenshots to Correct Folders



Before committing, manually copy your screenshots:



&#x20; waveforms/waveform\_full.png        ← simulation waveform

&#x20; reports/schematic.png              ← gate-level schematic

&#x20; reports/utilization\_report.png     ← 70 LUTs screenshot

&#x20; reports/power\_report.png           ← 3.307W screenshot



\---



\## STEP 7: Stage All Files



&#x20; git add .



Check what's staged:

&#x20; git status



You should see all .v files, .md files, screenshots listed in green.



\---



\## STEP 8: Commit in Stages (Professional Style)



Commit 1 — RTL:

&#x20; git add rtl/alu\_top.v

&#x20; git commit -m "feat: add parameterized 8-bit low-power ALU RTL module"



Commit 2 — Testbench:

&#x20; git add tb/alu\_tb.v

&#x20; git commit -m "feat: add self-checking testbench with 25+ test cases"



Commit 3 — Constraints:

&#x20; git add constraints/alu\_basys3.xdc

&#x20; git commit -m "feat: add Basys3 XDC constraints for FPGA implementation"



Commit 4 — Docs:

&#x20; git add docs/ simulation/ README.md .gitignore

&#x20; git commit -m "docs: add README, simulation guide, and interview Q\&A"



Commit 5 — Screenshots:

&#x20; git add waveforms/ reports/ images/

&#x20; git commit -m "chore: add waveform, schematic, utilization and power report screenshots"



\---



\## STEP 9: Connect to GitHub and Push



&#x20; git branch -M main

&#x20; git remote add origin https://github.com/your-username/Low-Power-ALU-Verilog.git

&#x20; git push -u origin main



It will ask for GitHub login:

&#x20; Username: your GitHub username

&#x20; Password: use Personal Access Token (NOT your GitHub password)



\---



\## STEP 10: Generate Personal Access Token (PAT)



GitHub changed password auth in 2021 — you need a token:



1\. GitHub → Settings → Developer Settings

2\. Personal Access Tokens → Tokens (classic)

3\. Generate new token (classic)

4\. Note: "vivado-project-upload"

5\. Expiration: 90 days

6\. Check: repo (full control)

7\. Click Generate Token

8\. COPY IT NOW — shown only once

9\. Paste it as your password when git push asks



\---



\## STEP 11: Verify Upload



Go to: https://github.com/your-username/Low-Power-ALU-Verilog



You should see:

&#x20; ✅ All folders visible

&#x20; ✅ README.md rendered on homepage

&#x20; ✅ Screenshots visible in waveforms/ and reports/



\---



\## STEP 12: Add GitHub Topics (Tags)



On your repo page:

&#x20; Click the gear icon ⚙ next to "About"

&#x20; Add topics:

&#x20;   verilog

&#x20;   vlsi

&#x20;   alu

&#x20;   rtl-design

&#x20;   low-power

&#x20;   fpga

&#x20;   digital-design

&#x20;   vivado

&#x20;   artix-7

&#x20;   student-project



\---



\## STEP 13: Pin Repository on Profile



1\. Go to your GitHub profile page

2\. Click "Customize your pins"

3\. Select Low-Power-ALU-Verilog

4\. Click Save



\---



\## COMMON ERRORS



ERROR: "src refspec main does not match any"

FIX: You forgot to commit. Run git add . then git commit first.



ERROR: "remote origin already exists"

FIX: git remote remove origin → then add again



ERROR: Authentication failed

FIX: Use Personal Access Token as password, not GitHub password



ERROR: "fatal: not a git repository"

FIX: You're in the wrong folder. cd into your project folder first.

