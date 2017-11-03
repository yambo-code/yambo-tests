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
subroutine eval_the_moments(fl)
 !
 use DIFF
 type(obj) :: fl
 real(SP)  :: RIntegrate,W(fl%N),dW,W2(fl%N)
 fl%Max=-1.
 dW=1./(fl%N-1)
 do i_d=1,fl%N
   W(i_d)=(i_d-1)*dW
 enddo
 do i_c=1,fl%N_col
   if (skip_column(i_c)) cycle
   do i_d=1,fl%N
     fl%Max(i_c)=max(fl%Max(i_c),abs(fl%D(i_d,i_c)))
   enddo
   do i_m=1,N_m
     do i_d=1,fl%N
       W2(i_d)=W(i_d)
       if (i_m>1) W2(i_d)=W(i_d)**(i_m-1)
     enddo
     fl%M(i_m,i_c)=RIntegrate(fl%D(:,i_c),W2,fl%N)
   enddo
 enddo
 !
end subroutine
!
subroutine broad_the_data(N,x,y)
 implicit none
 integer, parameter :: SP  = selected_real_kind(6,30)
 real(SP),parameter :: pi=3.141592653589793238462643383279502884197_SP
 integer :: N,i,j
 real(SP):: x(N),y(N),y_(N),dX
 real(SP), external :: Fermi_fnc_derivative
 y_=0.
 dX=(x(N)-x(1))/10.
 do i=1,N
   do j=1,N
     y_(i)=y_(i)+y(j)/(dX*sqrt(2*pi))*exp(-(x(i)-x(j))**2/2./dX**2)
   enddo
 enddo
 y=y_
end subroutine
!
function RIntegrate(F,W,N)
 !
 implicit none
 !
 integer, parameter  :: SP  = selected_real_kind(6,30)
 !
 integer,     intent(in)  :: N
 real(SP),    intent(in)  :: W(N),F(N)
 real(SP)                 :: RIntegrate
 !
 ! Work Space
 !
 integer      :: i_w
 real(SP)     :: M,Q
 !
 RIntegrate=0._SP
 !
 do i_w=1,N-1
   M=(F(i_w)-F(i_w+1))/(W(i_w)-W(i_w+1))
   Q=F(i_w)-M*W(i_w)
   RIntegrate=RIntegrate+1./2.*M*(W(i_w+1)**2.-W(i_w)**2.)+Q*(W(i_w+1)-W(i_w))
 enddo
 !
end function
!
character(256) function string_remove(string_in,what)
 !
 character(*)     :: string_in
 character(*)     :: what
 !
 ! Work Space
 !
 integer          :: i_pos
 !
 string_remove=string_in
 i_pos=index(string_in,what)
 if (i_pos==0) return
 write (string_remove,'(2a)') string_in(:i_pos-1),string_in(i_pos+len(what):)
 !
end function
!
subroutine string_split(string_in,string_out,n_non_empty_strings)
  ! 
  use DIFF 
  ! 
  implicit none
  !
  character(*)          :: string_in
  character(256)        :: string_out(N_max_col)
  integer               :: n_non_empty_strings
  !
  ! Work Space
  !
  integer          :: i_pos(2),is
  character(1)     :: space_=" "
  !
  i_pos=(/1,1/)
  is=0
  string_out=""
  do while (i_pos(1)<=len_trim(string_in))
    !
    ! Here I go to the first non null characater " AB  C"
    !                                              |
    do while (string_in(i_pos(1):i_pos(1)) == space_)
      if (i_pos(1)==len_trim(string_in)) exit
      i_pos(1)=i_pos(1)+1
    enddo
    !
    ! Here I go to the last non-null characater before a space " AB  C"
    !                                                             |   
    i_pos(2)=i_pos(1)
    do while (string_in(i_pos(2):i_pos(2)) /= space_)
      if (i_pos(2)==len_trim(string_in)) exit
      i_pos(2)=i_pos(2)+1
    enddo
    if(i_pos(2)<len_trim(string_in)) i_pos(2)=i_pos(2)-1
    ! 
    is=is+1
    string_out(is)=trim(string_in(i_pos(1):i_pos(2)))
    i_pos(1)=i_pos(2)+1
    !
    if (i_pos(2)==len_trim(string_in)) exit
    !
  enddo
  !
  n_non_empty_strings=0
  do is=1,size(string_out)
    if (len_trim(string_out(is))>0) n_non_empty_strings=n_non_empty_strings+1
  enddo
  !
end subroutine
!
subroutine arg_check()
 use DIFF
  if (  len_trim(str1) ==0 ) stop 'STOP! Reading argument error'
end subroutine