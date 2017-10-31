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
call add_RULE(".YPP-RT_occupations_DATA","skip",MATERIAL="Si_bulk")
call add_RULE(".YPP-RT_","no_statistics",MATERIAL="Si_bulk")
call add_RULE(".mean_EPlifetimes","skip",TITLES=(/"T Hole  [K]","T Elec  [K]"/),MATERIAL="Si_bulk")
call add_RULE(".current","average",COLS=(/2,3,4/),VAL_treshold=1.E-10,MATERIAL="hBN AlAs Si_bulk")
call add_RULE(".polarization","average",COLS=(/2,3,4/),MATERIAL="hBN AlAs")
call add_RULE("-eps_along_E","skip",TITLES=(/"eps_d2","eps_d3"/),MATERIAL="hBN AlAs MoS2 WSe2 H2")
call add_RULE("-eels_along_E","skip",TITLES=(/"eel_d2","eel_d3"/),MATERIAL="hBN AlAs MoS2 WSe2 H2")
call add_RULE(".N_dN_E_conservation_factors","skip",MATERIAL="Si_bulk")
call add_RULE(".energy","skip",TITLES=(/"dE_xc [eV]","dE_tot[eV]"/),MATERIAL="MoS2 WSe2")
call add_RULE(".energy","no_statistics",USER_prec=5/100.,MATERIAL="hBN AlAs")
call add_RULE(".carriers","skip",TITLES=(/"T(hol) [K]","T(el)  [K]"/),MATERIAL="MoS2 WSe2 Si_bulk")
call add_RULE(".carriers","no_statistics",VAL_treshold=1.E-7,MATERIAL="hBN AlAs MoS2 WSe2 Si_bulk")
call add_RULE("o-04_elel+elph_0K.carriers","no_statistics",USER_prec=7/100.,MATERIAL="Si_bulk")
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
call add_RULE(".eps_q1_haydock_bse","skip",TITLES=(/"EPS`/Im[6]","EPS`/Re[7]"/))
call add_RULE(".eel_q1_haydock_bse","skip",TITLES=(/"EEL`/Im[6]","EEL`/Re[7]"/))
call add_RULE(".exc_weights_at","skip",COL=4)
!
! SC
!=====
call add_RULE(".SC_E_History","last_row no_statistics",REF_col=2,USER_error=0.005)
call add_RULE(".SC_E_History","skip",TITLE="Iteration")
