!
!        Copyright (C) 2000-2020 the YAMBO team
!              http://www.yambo-code.org
!
! Authors (see AUTHORS file for details): AM
! 
! This file is distributed under the terms of the GNU 
! General Public License. You can redistribute it and/or 
! modify it under the terms of the GNU General Public 
! License as published by the Free Software Foundation; 
! either version 2, or (at your option) any later version.
!
! This program is distributed in the hope that it will 
! be useful, but WITHOUT ANY WARRANTY; without even the 
! implied warranty of MERCHANTABILITY or FITNESS FOR A 
! PARTICULAR PURPOSE.  See the GNU General Public License 
! for more details.
!
! You should have received a copy of the GNU General Public 
! License along with this program; if not, write to the Free 
! Software Foundation, Inc., 59 Temple Place - Suite 330,Boston, 
! MA 02111-1307, USA or visit http://www.gnu.org/copyleft/gpl.txt.
!
module DIFF
 !
 implicit none
 !
 integer, parameter  :: str_length = 512
 integer, parameter  :: SP  = selected_real_kind(6,30)
 integer, parameter  :: N_m = 4,N_max_col=50,N_max_rules=500
 !
 character(str_length) :: str,str1,CHECK_result="OK",MATERIAL="any"
 character(str_length) :: data_str(N_max_col),titles(N_max_col)
 integer        :: ind,ierr,ivar,N,i_c,i_m,i_d,i_r,i_c_ref,i_t,i_rule=0,i_REF_col,i_REF_row,N_data_to_check
 character(13)  :: subname="find_the_diff"
 real(SP)       :: PREC=0.01,MAX_ERR_RULES,MAX_ERR,O_ref,R_ref,delta_ref,TRESHOLD,USER_error
 real(SP)       :: ERROR(N_max_col)
 logical        :: VERB=.FALSE.,skip_column(N_max_col)=.FALSE.,average_column(N_max_col)=.FALSE.,&
&                  l_out_exists,l_ref_exists,broad_data,last_row,no_statistics,l_whitelisted,&
&                  l_rules_skip,sort_data
 !
 type rule 
   character(str_length)         :: pattern  = "fake-pattern"
   character(str_length)         :: action   = " "
   character(str_length)         :: material = "any"
   integer                :: REF_col=0
   integer                :: REF_row=0
   integer                :: column(N_max_col) = 0
   character(str_length)         :: title(N_max_col)  = " "
   logical                :: whitelisted=.FALSE.
   real(SP)               :: prec = 0.1
   real(SP)               :: treshold = 0
   real(SP)               :: error = 0.
 end type rule
 !
 type obj 
   integer                :: unit      
   integer                :: N      
   integer                :: N_col
   character(str_length)         :: name      
   real(SP)               :: Max(N_max_col)
   real(SP)               :: M(N_m,N_max_col)
   real(SP), allocatable  :: D(:,:)
 end type obj
 !
 type(obj)            :: ref,out
 type(rule)           :: RULES(N_max_rules)
 character(str_length)       :: FILTER_action(N_max_col)= " ",FILTER_pattern=" ",ch_tmp
 !
end module
