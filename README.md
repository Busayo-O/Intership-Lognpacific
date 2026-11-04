<!-- banner --><a href="https://github.com/kenmwara"><img src="https://raw.githubusercontent.com/kenmwara/kenmwara/main/assets/brand/card-stig.png?v=1c210d14f2" 

# Windows 11 STIG remediation

**Fixed and validated 10 windows 11 security settings- each failed the official US Government(STIG) compliance checklist before, and passed after.**

This Project targets the DISA STIG for Windows 11,the security hardening standard used by the US Department of Defense. Each setting was remediated with a Powershell Script and confirmed compliant via authenticated Tenable scanning.

- **Checklist:** DISA Microsoft Windows 11 STIG v2r9, validated via Tenable compliance scan.
- **Target:** Windows 11 Pro 25H2 virtual machine on Azure LOG(N) Pacific Cyber Range.
- **Before:** 258 checks, 142 failed, 11 warnings, 105 passed (Oct 2026).
- **After:** 258 checks, 131 failed, 11 warnings, 116 passed. All 10 targeted settings now pass.

## At a glance

<img src="images/flow.png" width="100%" alt="Flow diagram: how each failed setting was fixed and proven. Start: run the DISA Windows 11 STIG audit as a scan that logs in: 258 checks, 142 failed (the scan needs the firewall opened, Remote Registry on and remote UAC relaxed, all put back afterwards). Take the next failed finding; ten were chosen (the host-firewall finding kept failing with Windows' own tools, so it was swapped). Write one PowerShell script that sets exactly that setting and prints the value back, run it as Administrator, rescan. Did the finding move from Failed to Passed? No: fix the script (the first security-log fix of 1,024,000 KB failed; the scan needed 5,120,000). Yes: any of the ten still to fix? Yes: next finding. No: end, 10 of 10 failed to passed; failed checks 142 to 131, passed 105 to 116.">

<sub>Editable diagram: [images/flow.drawio](images/flow.drawio) (opens in diagrams.net).</sub>

## The ten settings

<img src="images/the-ten.png" width="100%" alt="Ten settings that failed the checklist, each fixed and passed. Each one was fixed with a PowerShell script, then a Tenable scan logged in and checked it again. All ten moved from Failed to Passed. Record every program started: Windows logs each program that runs. Proof: Failed before; passed on the rescan Detailed audit rules win: The fine-grained logging rules override the broad ones. Proof: Failed before; passed on the rescan Bigger app log: The application log holds at least 32 MB. Proof: Failed before; passed on the rescan Bigger security log: The security log keeps a week of records (5 GB in this scan). Proof: Failed before; passed on the rescan Bigger system log: The system log holds at least 32 MB. Proof: Failed before; passed on the rescan Memory attack protection: A Windows defence against a common crash-and-hijack trick (SEHOP) is on. Proof: Failed before; passed on the rescan No 'run as someone else': The Secondary Logon service is switched off. Proof: Failed before; passed on the rescan No camera on the lock screen: The camera can't be used before signing in. Proof: Failed before; passed on the rescan No passwords kept in memory: WDigest, an old login method that leaves passwords readable, is off. Proof: Failed before; passed on the rescan Record every PowerShell script: The full text of each script that runs is logged. Proof: Failed before; passed on the rescan">

<details><summary>The ten as a table, with checklist IDs and scripts</summary>

| STIG ID | Finding | Before | After | Script |
|---|---|---|---|---|
| WN11-SO-000030 | Audit policy using subcategories must be enabled | Failed | Passed | [WN11-SO-000030.ps1](scripts/WN11-SO-000030.ps1) |
| WN11-SO-000030 | Audit subcategory settings must override category settings | Failed | Passed | [WN11-SO-000030.ps1](scripts/WN11-SO-000030.ps1) |
| WN11-AU-000165 | Application event log size ≥ 32768 KB | Failed | Passed | [WN11-AU-000500.ps1](scripts/WN11-AU-000500.ps1) |
| WN11-AU-000155 | Security event log size (one week of records; 5120000 KB in this audit) | Failed | Passed | [WN11-AU-000505.ps1](scripts/WN11-AU-000505.ps1) |
| WN11-AU-000145 | System event log size ≥ 32768 KB | Failed | Passed | [WN11-AU-000510.ps1](scripts/WN11-AU-000510.ps1) |
| WN11-00-000120 | Structured Exception Handling Overwrite Protection (SEHOP) enabled | Failed | Passed | [WN11-00-000150.ps1](scripts/WN11-00-000150.ps1) |
| WN11-00-000100 | Secondary Logon service disabled | Failed | Passed | [WN11-00-000175.ps1](scripts/WN11-00-000175.ps1) |
| WN11-CC-000205 | Camera access from the lock screen disabled | Failed | Passed | [WN11-CC-000005.ps1](scripts/WN11-CC-000005.ps1) |
| WN11-CC-000200 | WDigest authentication disabled | Failed | Passed | [WN11-CC-000038.ps1](scripts/WN11-CC-000038.ps1) |
| WN11-CC-000510 | PowerShell script block logging enabled | Failed | Passed | [WN11-CC-000326.ps1](scripts/WN11-CC-000326.ps1) |

</details>

## Method

A. Audit: Run the DISA Windows 11 STIG as a credentialed Tenable scan and record all failed checks.
   
B. Remediate:For each finding, create a PowerShell script that sets the exact registry/security policy value the STIG validates, then prints the value
   back as evidence.
   
C. Apply: Execute the script as Administrator on the VM.

D. Verify: Rescan with the same Tenable audit and confirm the finding status changed from failed to Passed.

## Lessons learned

- **Credential scans are everything.** A non-credentialed scan won't see STIG settings. The Tenable scan has to log in as a local admin to read registry and security policy correctly.
- **STIG check exact values and not intent.** It does not matter if the setting is secured enough, if the STIG says "0" and you set is as "1", you still fail.The fix has to match the exact value in the check. 
- **Run PowerShell as Administrator.** Half the scripts will silently fail or write to the wrong hive if you don't elevate. Always verify with `whoami /priv` and echo the value back after the set.
- **STIG versions move fast.** v2r9 added/changed checks from previous releases. Locking the audit file version in your repo prevents "it passed on my machine" issues.

## Using the scripts

Each script is standalone. Run it in an elevated PowerShell on the target, then rescan. The scripts only set the one
value their STIG checks; review them before running anywhere that is not a lab.

---

Ken Kariuki · [github.com/kenmwara](https://github.com/kenmwara) · [linkedin.com/in/kenmwara](https://linkedin.com/in/kenmwara)
