!
! Whitelisted files.
! 
! Those files are known to fail and the origin has been found and/or is under investigation.
!
! Thus are listed in REPORT in a dedicated field
!
! Format:
!
! call add_rule(PATTERN,"whitelist",MATERIAL)
!
! Example:
!
! call add_RULE("o-14_plot_0K_field_ad.YPP-RT_occupations_","whitelist",MATERIAL="Si_bulk")
!
! Dummy
!=======
call add_RULE("o-03_optics.eps_q1_inv_rpa_dyson","whitelist",MATERIAL="Dummy")
!
! RT
!====
! Noise...(?)
call add_RULE("03_fit_elel.YPP-RT_NEQ_linewidths","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-03_elel_SEX.carriers","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-04_fit_elel_plasma.YPP-RT_NEQ_linewidths","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-14_plot_0K_field_ad.YPP-RT_occupations","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-04_ypp_fit_occ.","whitelist",MATERIAL="WSe2")
call add_RULE("o-08_ypp_dos_occ_DbGd.YPP-2D_occ_dos","whitelist",MATERIAL="MoS2")
call add_RULE("o-03_elel.carriers","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-02_plot_elph_0K_adaptative.YPP-RT_occupations_k1_kRT1_b","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-08_ypp_plot_occ_DbGd.YPP-RT_occupations_k3_kRT16_b24","whitelist",MATERIAL="MoS2")
call add_RULE("_FIT_holes","whitelist")
call add_RULE("_FIT_electrons","whitelist")
call add_RULE("_FIT_electrons","whitelist")
call add_RULE(".YPP-RT_E_Fermi","whitelist")
call add_RULE(".YPP-RT_Temperatures","whitelist")
!
! It seems like in a parallel run the energy explodes. Accumulation of errors?
call add_RULE("o-03_tdlda.energy","whitelist",MATERIAL="H2")
!
! Thermodynamics is affected by numerical noise due to addition/removal of values.
call add_RULE(".thermodynamics","whitelist")
!
! MAGNETIC
!==========
! Potential bugs and/or numerical problems.
call add_RULE("o-02_sc_magnetic.SC_E_History","whitelist",MATERIAL="Si_bulk")
call add_RULE("o-02_sc_magnetic+qp.SC_E_History","whitelist",MATERIAL="Si_bulk")
!
! KERR
!======
! Noise...
call add_RULE("o-05_KERR_IP-RPA_len.moke_q1_IP","whitelist",MATERIAL="Iron")
call add_RULE("o-05_KERR_IP-RPA_vel.moke_q1_IP","whitelist",MATERIAL="Iron")
call add_RULE("o-05_KERR_IP-RPA_vel.off_q1_IP","whitelist",MATERIAL="Iron")
!
! QP
!====
call add_RULE("o-03_QP_COHSEX_drude.ndb.em1s_fragment_1","whitelist",MATERIAL="Al_bulk")
!
! BSE
!=====
call add_RULE("o-06_ypp_sort.exc_E_sorted","whitelist",MATERIAL="hBN")
call add_RULE("o-06_ypp_sort.exc_I_sorted","whitelist",MATERIAL="hBN")
!
! SC
!=====
call add_RULE("o-06_h_using_colls.SC_E_History","whitelist",MATERIAL="Si_bulk")
