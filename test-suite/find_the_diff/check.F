!
!        Copyright (C) 2000-2017 the YAMBO team
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
subroutine check(R,O,REPORT,FIELD)
  use DIFF
  real(SP) :: R(N_max_col),O(N_max_col),DATA_diff
  real(SP) :: R_average,O_average
  logical  :: REPORT
  character(*) :: FIELD
  !
  R_average=0.
  O_average=0.
  !
  do i_c=1,ref%N_col
    !
    if (average_column(i_c)) then
      R_average=R_average+R(i_c)
      O_average=O_average+O(i_c)
      cycle
    endif
    !
    if (skip_column(i_c)) cycle
    DATA_diff=abs(R(i_c)-O(i_c))
    if (DATA_diff>ERROR(i_c)) then 
      if (DATA_diff>MAX_ERR) then
        MAX_ERR=DATA_diff
        O_ref=O(i_c)
        R_ref=R(i_c)
        if (abs(ERROR(i_c))>0.) delta_ref=DATA_diff/ERROR(i_c)*PREC
        i_c_ref=i_c
        str=FIELD
        if (i_d>0) write (str,'(a,i4,a)') FIELD//'(#',i_d,')'
      endif
    endif
  enddo
  !
  if (any(average_column)) then
    DATA_diff=abs(R_average-O_average)
    if (DATA_diff>maxval(ERROR(:ref%N_col))) then 
      if (DATA_diff>MAX_ERR) then
        MAX_ERR=DATA_diff
        O_ref=O_average
        R_ref=R_average
        if (abs(maxval(ERROR(:ref%N_col)))>0.) delta_ref=DATA_diff/maxval(ERROR(:ref%N_col))*PREC
        i_c_ref=-1
        str=FIELD
        if (i_d>0) write (str,'(a,i4,a)') FIELD//'(#',i_d,')'
      endif
    endif
  endif
  !
  if (REPORT.and.i_c_ref/=0) then
    !
    if (l_whitelisted) str=trim(str)//"[>WHITELISTED<]"
    !
    if (i_c_ref>0) then
      write (CHECK_result,'(a,i3,a,3(g12.5,a))') trim(str)//"@COL#",i_c_ref," is ",R_ref," [REF] vs ",&
       O_ref," [OUT] corresponding to", abs(delta_ref)*100," [% RELATIVE TO MAX]"
    else
      write (CHECK_result,'(a,3(g12.5,a))') trim(str)//"@AVERAGE# is ",R_ref," [REF] vs ",&
       O_ref," [OUT] corresponding to", abs(delta_ref)*100," [% RELATIVE TO MAX]"
    endif
    !
  endif
end subroutine
