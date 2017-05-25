!
! Possible FORMATs:
!
!  call add_RULE("PATTERN","action",OPTIONS...)
!
! pattern identifies the file
! action can be: average, skip, skip_and_precision, broad, double_precision
! 
! Columns can be given in OPTIONS as:
!
! 1. COLS=(/col_start,col_end/): starting and ending columns
! 2. COL=col
! 3. TITLES=(/"T1","T2"/): titles of the column
! 4. MATERIAL="hBN". Applies to a specific material
!
! The same pattern can be used more than one time to add rules
!
! RT
!====
call add_RULE(".current","average",COLS=(/2,3,4/),MATERIAL="hBN AlAs")
call add_RULE(".polarization","average",COLS=(/2,3,4/),MATERIAL="hBN AlAs")
call add_RULE("-eps_along_E","skip",TITLES=(/"eps_d2","eps_d3"/),MATERIAL="hBN AlAs MoS2 WSe2 H2")
call add_RULE("-eels_along_E","skip",TITLES=(/"eel_d2","eel_d3"/),MATERIAL="hBN AlAs MoS2 WSe2 H2")
call add_RULE(".thermodynamics","skip",TITLES=(/"T    [K]","T(h) [K]","T(e) [K]"/),MATERIAL="hBN AlAs MoS2 WSe2 Si_bulk H2")
call add_RULE(".carriers","skip",TITLE="dN",MATERIAL="Si_bulk")
call add_RULE(".carriers","skip",TITLES=(/"T(hol) [K]","T(el)  [K]"/),MATERIAL="MoS2 WSe2 Si_bulk")
call add_RULE(".energy","skip",TITLES=(/"dE_xc [eV]","dE_tot[eV]"/),MATERIAL="MoS2 WSe2")
call add_RULE(".N_dN_E_conservation_factors","skip",MATERIAL="Si_bulk")
call add_RULE(".energy","skip",TITLES=(/"dE_xc [eV]","dE_tot[eV]"/),MATERIAL="MoS2 WSe2")
call add_RULE(".YPP-RT_","no_statistics",MATERIAL="Si_bulk")
call add_RULE(".carriers","no_statistics")
call add_RULE(".energy","no_statistics")
!
! KERR
!======
call add_RULE("any","no_statistics",MATERIAL="Cobalt Nickel Iron")
!
! QP
!====
call add_RULE(".qp","skip",TITLE="E-Eo(Mhz)")
call add_RULE("Lifetimes.qp","skip",TITLE="Width[fs]",MATERIAL="Al_bulk")
call add_RULE("o-03_OMS_RIM.qp","skip",TITLE="Width[meV]",MATERIAL="Si_bulk")
call add_RULE("o-03_OMS_RIM.qp","double_precision",MATERIAL="Si_bulk")
!
! BSE
!=====
call add_RULE(".eps_q1_haydock_bse","skip",TITLES=(/"eps`/Im[6]","eps`/Re[7]"/))
call add_RULE(".eel_q1_haydock_bse","skip",TITLES=(/"EEL`/Im[6]","EEL`/Re[7]"/))
call add_RULE(".exc_weights_at","skip",COL=4)
!
! SC
!=====
call add_RULE(".SC_E_History","last_row",MATERIAL="Si_bulk")
call add_RULE(".SC_E_History","average",COLS=(/2,3,4/),MATERIAL="Si_bulk")
call add_RULE(".SC_E_History","no_statistics")
