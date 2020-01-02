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
subroutine read_the_data(fl)
  use DIFF
  type(obj)      :: fl
  integer        :: i_cyc,tit_length,i1_pos
  character(256) :: ch_save(3)=" ",fmt_,head,str_hash
  do i_cyc=1,2
    open(unit=fl%unit,file=trim(fl%name),form='formatted')
    N=0
    ierr=0
    i_d=0
    do while(ierr==0)
      read(fl%unit,'(a)',iostat=ierr) str(1:256)
      if (ierr/=0) cycle
      call string_split(trim(str),data_str,N)
      if (index(str,"[")>0.and.trim(data_str(1))/="#") then
         str(index(str,"["):256)=" "
         call string_split(trim(str),data_str,N)
      endif
      ch_save(1)=ch_save(2)
      ch_save(2)=ch_save(3)
      ch_save(3)=str
      if ( (index(trim(fl%name),".xsf")>0.or.index(trim(fl%name),".cube")>0).and.N>1 ) cycle
      str_hash=data_str(1)
      if (str_hash(1:1)=="#".or.N==0.or.&
&         trim(data_str(1))=="CUBE".or.&
&         trim(data_str(1))=="Generated".or.&
&         trim(data_str(1))=="CRYSTAL".or.&
&         trim(data_str(1))=="PRIMVEC".or.&
&         trim(data_str(1))=="PRIMCOORD".or.&
&         trim(data_str(1))=="BEGIN_DATAGRID_2D".or.&
&         trim(data_str(1))=="BEGIN_BLOCK_DATAGRID_2D".or.&
&         trim(data_str(1))=="END_DATAGRID_2D".or.&
&         trim(data_str(1))=="END_BLOCK_DATAGRID_2D".or.&
&         trim(data_str(1))=="BEGIN_DATAGRID_3D".or.&
&         trim(data_str(1))=="BEGIN_BLOCK_DATAGRID_3D".or.&
&         trim(data_str(1))=="END_DATAGRID_3D".or.&
&         trim(data_str(1))=="END_BLOCK_DATAGRID_3D"&
&        ) cycle
      i_d=i_d+1
      fl%N_col=N
      do i_c=1,N
        if (i_cyc==2) read (data_str(i_c),*) fl%D(i_d,i_c)
      enddo
      if (i_d==1.and.i_cyc==2) then 
        call string_split(trim(ch_save(1)),data_str,N)
        if (N/=fl%n_col+1) then
          i1_pos=index(ch_save(1),trim(data_str(2)))
          head=ch_save(1)
          head=head(i1_pos:len_trim(ch_save(1)))
          tit_length=nint(real(len_trim(head))/fl%n_col)+1
          write (fmt_,'(i2.2,a1,i2.2)') fl%N_col,"A",tit_length
          read(head,'('//trim(fmt_)//')') data_str(1:fl%N_col)
          !do i_c=1,fl%N_col
          !  write (*,*) '|',trim(data_str(i_c)),'|'
          !enddo
          titles(1:fl%N_col)=data_str(1:fl%N_col)
        else
          titles(1:fl%N_col)=data_str(2:fl%N_col+1)
        endif
      endif
    enddo
    fl%N=i_d
    close(fl%unit)
    if (i_cyc==1) allocate( fl%D(fl%N,fl%N_col) )
  enddo
end subroutine
!

