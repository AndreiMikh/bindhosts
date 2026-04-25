# BINDHOSTS OPERATING MODES
- These are Currently Defined Operating Modes that are Either Probed at Auto or Available as Opt-in..
- You can Change Operating Mode by Accessing to Developer Option..

#### GLOSSARY OF TERMS
 - Magic Mount - Mounting Method Primarily Used by Magisk..
 - SUSFS - Advanced Root-Hiding Framework Provided as a Kernel Patch Set..

---

## Mode 0
### DEFAULT MODE
 - **APatch** 
   - Bind Mount (Magic Mount)..
   - AdAway Compatible..
   - Hiding: Exclude Modifications + ZygiskNext Umount Only..
 - **Magisk** 
   - Magic Mount..
   - AdAway Compatible..
   - Hiding: Denylist / Shamiko..
 - **KernelSU** 
   - OverlayFS + Path Umount, (Magic Mount)..
   - No AdAway Compatibility..
   - Hiding: Umount Modules (For Non-GKI, Backport Path Umount)..

---

## Mode 1
### KSU SUSFS BIND
- SUSFS Assisted Mount Bind..
- KernelSU Only..
- Requires SUSFS Patched Kernel and Userspace Tool..
- AdAway Compatible..
- Hiding: SUSFS Handles the Umount..

---

## Mode 2
### PLAIN BINDHOSTS
- Mount Bind
- **Highest Compatibility**
- Actually Works on All Managers..
- Will Leak a Bind Mount and a Globally Modified Hosts File if Unassisted..
- Selected when APatch is on OverlayFS (Default Mode) as it Offers better Compatibility..
- Selected when a Known "Denylist Handler" is Found..
- AdAway Compatible..
- Hiding: Requires Assisted Hiding..

---

## Mode 3
### APATCH HFR, HOSTS FILE REDIRECT
- In-Kernel Redirection of /SYSTEM/ETC /HOSTS for UID 0
- APatch Only, Requires Hosts File Redirect KPM..
- Does Not Work on All Setups, Hit-and-Miss..
- No AdAway Compatibility..
- Hiding: Good Method if it Works. 

---

## Mode 4
### ZYGISK HOSTS REDIRECT
- Zygisk Netd Injection .
- Usage is **Encouraged**..
- Injection is Much Better Than Mount in this Usecase..
- No AdAway Compatibility..
- Hiding: Good Method as There's No Mount at All, But it Depends on Other Modules..

---

## Mode 5
### KSU SUSFS OPEN REDIRECT
- In-Kernel File Redirects for UID Below 2000. 
- KernelSU Lnly..
- **Opt-in** Only..
- Requires SUSFS Patches Kernel and Userspace Tool..
- Usage is **Discouraged**
- Requires SUSFS v1.5.1 or Later.. 
- AdAway Compatible..
- Hiding: Good Method but will Likely Waste More CPU Cycles..

---

## Mode 6
### KSU SOURCE MOD
- KernelSU Try Umount Assisted Mount Bind..
- Requires Source Modification..
- **WARNING**: Conflicts with SUSFS. You Don't Need this if you can Implement SUSFS..
- AdAway Compatible..
- Hiding: Good Method but you can Probably just Implement SUSFS..

---

## Mode 7
### GENERIC OVERLAYFS
- Generic OverlayFS RW Mount..
- Should Work on All Managers..
- **Opt-in** Only Due to **Awfully High** Susceptability to Detections
- Leaks an OverlayFS Mount, Leaks Globally Modified Hosts File..
- Will Not Likely Work on APatch Bind Mount / MKSU if User has Native F2FS / Data Casefolding..
- AdAway Compatible..
- Hiding: Essentially No Hiding, Needs Assistance..

---

## Mode 8
### KSU SUSFS OVERLAYFS
- SUSFS Assisted OverlayFS RW Mount..
- KernelSU Only..  
- Requires SUSFS Patched Kernel and Userspace Tool..
- Will Not Likely Work on APatch Bind Mount / MKSU if User has Native F2FS / Data Casefolding..
- AdAway Compatible..
- Hiding: Good Method but KSU SUSFS Bind is Easier..

---

## Mode 9
### KSU SUSFS BIND KSTRAT
- SUSFS assisted Mount Bind + Kstat Spoofing..
- KernelSU Only..  
- Requires SUSFS Patched Kernel and Userspace Tool..
- **Opt-in** Only Due to it Being Niche
- AdAway Compatible..
- Hiding: SUSFS Handles the Umount..

---

## Mode 10
### KSUD KERNEL UMOUNT
- Mount Bind + Kernel Assisted Umount..
- KernelSU Only..  
- Requires KernelSU v22106 or Later..
- AdAway Compatible..

