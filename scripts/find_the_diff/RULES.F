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
subroutine add_RULE(PATTERN,RULE,TITLE,TITLES,COL,COLS,MATERIAL,USER_prec,&
&                   VAL_treshold,REF_col,USER_error)
  !
  use DIFF, ONLY:SP,RULES,i_c,i_t,i_rule,N_max_col
  !
  implicit none
  character(*) :: PATTERN,RULE
  character(*), optional ::TITLE
  character(*), optional ::TITLES(:)
  character(*), optional ::MATERIAL
  integer,      optional ::REF_col
  integer,      optional ::COL
  integer,      optional ::COLS(:)
  real(SP),     optional ::USER_prec
  real(SP),     optional ::USER_error
  real(SP),     optional ::VAL_treshold
  !
  integer        :: N,i_r
  character(256) :: str(N_max_col)
  !
  if (present(MATERIAL)) then
    call string_split(MATERIAL,str,N)
  else
    N=1
  endif
  !
  do i_r=1,N
    !
    i_rule=i_rule+1
    !
    RULES(i_rule)%pattern=PATTERN
    RULES(i_rule)%action=RULE
    !
    if (RULE=="whitelist") then
      RULES(i_rule)%whitelisted=.TRUE.
    endif
    !
    if (present(MATERIAL)) then
      RULES(i_rule)%material=trim(str(i_r))
    endif
    !
    if (present(COL)) then
      RULES(i_rule)%column(COL)=1
    endif
    !
    if (present(COLS)) then
      do i_c=1,size(COLS)
        RULES(i_rule)%column(COLS(i_c))=1
      enddo
    endif
    !
    if (present(TITLES)) then
      do i_t=1,size(TITLES)
        RULES(i_rule)%title(i_t)=trim(TITLES(i_t))
      enddo
    endif
    !
    if (present(USER_prec)) then
      RULES(i_rule)%action=trim(RULES(i_rule)%action)//" USER_prec"
      RULES(i_rule)%prec=USER_prec
    endif
    !
    if (present(USER_error)) then
      RULES(i_rule)%action=trim(RULES(i_rule)%action)//" USER_error"
      RULES(i_rule)%error=USER_error
    endif
    !
    if (present(VAL_treshold)) then
      RULES(i_rule)%action=trim(RULES(i_rule)%action)//" TRESHOLD"
      RULES(i_rule)%treshold=VAL_treshold
    endif
    !
    if (present(TITLE)) then
      RULES(i_rule)%title(1)=trim(TITLE)
    endif
    !
    if (present(REF_col)) then
      RULES(i_rule)%REF_col=REF_col
    endif
    !
    if (RULE=="skip".and..not.present(COL).and..not.present(COLS).and..not.present(TITLE).and..not.present(TITLEs)) then
      RULES(i_rule)%column=1
    endif
    !
  enddo
  !
end subroutine
