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
program find_the_diff
 !
 use DIFF
 !
 implicit none
 !
 interface
   !
   subroutine add_RULE(PATTERN,RULE,TITLE,TITLES,COL,COLS,MATERIAL,USER_prec,&
&                      VAL_treshold,REF_col,REF_row,USER_error)
    use DIFF, ONLY:SP
    character(*) :: PATTERN,RULE
    character(*), optional ::TITLE
    character(*), optional ::TITLES(:)
    character(*), optional ::MATERIAL
    integer,      optional ::REF_col
    integer,      optional ::REF_row
    integer,      optional ::COL
    integer,      optional ::COLS(:)
    real(SP),     optional ::USER_error
    real(SP),     optional ::USER_prec
    real(SP),     optional ::VAL_treshold
   end subroutine
   !
 end interface
 !
 integer               :: iargc,nargs
 integer,  allocatable :: INDX(:)
 real(SP), allocatable :: tmp(:)
 !
 INCLUDE '../../config/RULES.h'
 INCLUDE '../../config/WHITELIST.h'
 !
 ! get cmd line options
 !
 nargs = iargc ()
 if ( nargs < 1 ) then 
   write(*,"(a)") " Usage:"
   write(*,"(a)") 
   write(*,"(a)") " find_the_diff -r file1 -o fil2 -p high -m material -v"
   write(*,"(a)") 
   write(*,"(a)") " -r, --ref       Reference file"
   write(*,"(a)") " -o, --out       Output file"
   write(*,"(a)") " -p, --prec      Precision"
   write(*,"(a)") " -m, --mat       Material"
   write(*,"(a)") " -v              Be verbose"
   write(*,"(a)") 
   stop
 endif
 !
 ind=1
 do while (ind <= nargs)
   !
   call getarg(ind,str)
   call getarg(ind+1,str1)
   !
   select case ( trim(str) )
     case ("-r", "--ref") 
       call arg_check(str1)
       ref%name=str1
     case ("-o", "--output") 
       call arg_check(str1)
       out%name=str1
     case ("-m", "--material") 
       call arg_check(str1)
       MATERIAL=str1
     case ("-p", "--precision") 
       call arg_check(str1)
       read(str1,*,iostat=ierr) PREC
     case ("-v") 
       VERB=.TRUE.
   end select
   !
   ind=ind+2
   !
 enddo 
 !
 if (nargs==1 .and. VERB ) then
   write(*,"(a)") " RULEs:"
   write(*,"(a)") 
   do i_r=1,N_max_rules
     !
     ch_tmp=''
     !
     if (len_trim(RULES(i_r)%action)==0) cycle
     !
     write(*,"(t2,a,i2.2,2a)    ") "#",i_r," action    :", trim(RULES(i_r)%action)
     write(*,"(t5,       2a)    ")         " pattern   :", trim(RULES(i_r)%pattern)
     do i_c=1,N_max_col
       if (RULES(i_r)%column(i_c)==1) write (ch_tmp,'(a," ",i4)') trim(ch_tmp),i_c
       if (len_trim(RULES(i_r)%title(i_c))>0) write (ch_tmp,'(a," ",a)') trim(ch_tmp),trim(RULES(i_r)%title(i_c))
     enddo
     if (count(RULES(i_r)%column==1)==N_max_col) ch_tmp="all"
  
     write(*,"(2a)")                   "     columns   :",trim(ch_tmp)
     !
   enddo
   stop
 endif
 !
 ref%unit=1
 out%unit=2
 !
 INQUIRE( FILE = TRIM( ref%name ), EXIST = l_ref_exists )
 INQUIRE( FILE = TRIM( out%name ), EXIST = l_out_exists )
 !
 if (.not.l_ref_exists) then 
   write (*,"(a)") trim(ref%name)//" does not exist"
   stop
 endif
 !
 if (.not.l_out_exists) then 
   write (*,"(a)") trim(out%name)//" does not exist"
   stop
 endif
 !
 call read_the_data(ref)
 call read_the_data(out)
 !
 sort_data=.FALSE.
 broad_data=.FALSE.
 last_row=.FALSE.
 skip_column=.FALSE.
 no_statistics=.FALSE.
 average_column=.FALSE.
 l_whitelisted=.FALSE.
 l_rules_skip=.FALSE.
 TRESHOLD=1.E-12
 PREC=0.05
 ERROR=1.
 USER_error=0.
 !
 do i_r=1,N_max_rules
   if ( (index(out%name,trim(RULES(i_r)%pattern))  >0 .or. trim(RULES(i_r)%pattern)=="any" ).and. &
&       (index(MATERIAL,trim(RULES(i_r)%material)) >0 .or. trim(RULES(i_r)%material)=="any") ) then
     !
     if (index(RULES(i_r)%action,"USER_error")>0) USER_error=RULES(i_r)%error
     if (index(RULES(i_r)%action,"USER_prec")>0)  PREC=RULES(i_r)%prec
     if (index(RULES(i_r)%action,"TRESHOLD") >0)  TRESHOLD=RULES(i_r)%treshold
     !
     if (RULES(i_r)%REF_col>0) i_REF_col=RULES(i_r)%REF_col
     if (RULES(i_r)%REF_row>0) i_REF_row=RULES(i_r)%REF_row
     !
     if (.not.sort_data) sort_data=index(RULES(i_r)%action,"sort")>0
     if (.not.broad_data)broad_data=index(RULES(i_r)%action,"broad")>0
     if (.not.last_row)  last_row  =index(RULES(i_r)%action,"last_row")>0
     if (.not.no_statistics)    no_statistics  =index(RULES(i_r)%action,"no_statistics")>0
     if (index(RULES(i_r)%action,"skip")>0   ) then
       do i_c=1,max(ref%N_col,out%N_col)
         if (.not.skip_column(i_c)) skip_column(i_c)=RULES(i_r)%column(i_c)==1
         do i_t=1,ref%N_col
           if (len_trim(titles(i_c))==0) cycle
           if (len_trim(RULES(i_r)%title(i_t))==0) cycle
           if (.not.skip_column(i_c).and.len_trim(RULES(i_r)%title(i_t))>0) then
             skip_column(i_c)=index(titles(i_c),trim(RULES(i_r)%title(i_t)))>0
           endif
         enddo
       enddo
     endif
     !
     if (index(RULES(i_r)%action,"average")>0) average_column=(RULES(i_r)%column==1)
     if (index(RULES(i_r)%action,"double_precision")>0) ERROR=2.
     !
     if (.not.l_whitelisted) l_whitelisted=RULES(i_r)%whitelisted
     !
   endif
 enddo
 !
 l_rules_skip=all(skip_column(:ref%N_col))
 !
 if (last_row) then
   ref%D(1,:)=ref%D(ref%N,:)
   ref%N=1
   out%D(1,:)=out%D(out%N,:)
   out%N=1
 endif
 !
 if (i_REF_col>0.and..not.sort_data) then
   do i_r=1,ref%N
     do i_c=1,ref%N_col
       if (i_c==i_REF_col) cycle
       out%D(i_r,i_c)=out%D(i_r,i_c)-out%D(i_r,i_REF_col)
       ref%D(i_r,i_c)=ref%D(i_r,i_c)-ref%D(i_r,i_REF_col)
     enddo
     out%D(i_r,i_REF_col)=0.
     ref%D(i_r,i_REF_col)=0.
   enddo
 endif
 !
 if (i_REF_row>0) then
   do i_c=1,ref%N_col
     if (i_REF_col>0 .and. i_c==i_REF_col) cycle
     do i_r=1,ref%N
       if (i_r==i_REF_row) cycle
       out%D(i_r,i_c)=out%D(i_r,i_c)-out%D(i_REF_row,i_c)
       ref%D(i_r,i_c)=ref%D(i_r,i_c)-ref%D(i_REF_row,i_c)
     enddo
     out%D(i_REF_row,i_c)=0.
     ref%D(i_REF_row,i_c)=0.
   enddo
 endif
 !
 if (broad_data) then
   do i_c=2,ref%N_col
     call broad_the_data(ref%N,ref%D(:,1),ref%D(:,i_c))
     call broad_the_data(out%N,ref%D(:,1),out%D(:,i_c))
   enddo
 endif
 !
 if (sort_data) then
   allocate(INDX(ref%N),tmp(ref%N))
   call sort(ref%N,ref%D(1:ref%N,i_REF_col),INDX)
   call sort(out%N,out%D(1:out%N,i_REF_col),INDX)
   do i_c=2,ref%N_col
     do i_r=1,ref%N
       tmp(i_r)=ref%D(INDX(i_r),i_c)
     enddo
     ref%D(:ref%N,i_c)=tmp
   enddo
   do i_c=2,out%N_col
     do i_r=1,out%N
       tmp(i_r)=out%D(INDX(i_r),i_c)
     enddo
     out%D(:out%N,i_c)=tmp
   enddo
   deallocate(tmp)
 endif
 !
 N_data_to_check=min(ref%N,out%N)
 !
 if (abs(ref%N-out%N)>10) then
   write (CHECK_result,'(a,2(i6,a))') "Number of rows differ by more than 10:",ref%N," [REF]",out%N," [OUT]"
   write (*,'(a)') trim(CHECK_result)
   stop
 endif
 !
 call eval_the_moments(ref,N_data_to_check) 
 call eval_the_moments(out,N_data_to_check)
 !
 do i_c=1,ref%N_col
   ERROR(i_c)=ERROR(i_c)*PREC*ref%Max(i_c)
   if (ERROR(i_c)<TRESHOLD) ERROR(i_c)=1.E-5
   if (USER_error>0.) ERROR(i_c)=USER_error
 enddo
 !
 if ( VERB  ) then 
   write(*,"(a)") 
   write(*,"(2a)")   " REF (file)    :",trim(ref%name)
   write(*,"(a,i4)") "     (elements):",ref%N
   write(*,"(a,i2)") "     (columns) :",ref%N_col
   write(*,"(2a)")   " OUT (file)    :",trim(out%name)
   write(*,"(a,i4)") "     (elements):",out%N
   write(*,"(a,i2)") "     (columns) :",out%N_col
   write(*,"(a)")    " TITLES         "
   do i_c=1,ref%N_col
     write(*,"(a)")    "               :"//trim(titles(i_c))
   enddo
   write(*,"(a)") "                   REF                 OUT"
   do i_c=1,ref%N_col
     write(*,"(a,i2,2g20.10)")  " MAX@COLUMN #",i_c,ref%Max(i_c),out%Max(i_c)
     do i_m=1,N_m
       write(*,"(a,i2,a,i2,2g20.10)")  " M(",i_m,")@COLUMN #",i_c,ref%M(i_m,i_c),out%M(i_m,i_c)
     enddo
   enddo
 endif
 !
 if (ref%N_col/=out%N_col) then
   if( .not.(abs(ref%N_col-out%N_col)==count(skip_column)) ) then
     write (CHECK_result,'(a,2(i6,a))') "Different number of columns:",ref%N_col," [REF]",out%N_col," [OUT]"
     write (*,'(a)') trim(CHECK_result)
     stop
   endif
 endif
 !
 MAX_ERR=0.
 MAX_ERR_RULES=0.
 i_c_ref=0
 str= " "
 i_d=0
 !if (.not.no_statistics) call check(ref%Max,out%Max,.TRUE.,"AVERAGE")
 call check(ref%Max,out%Max,.TRUE.,"AVERAGE")
 !
 if (ref%N_col>1.and..not.no_statistics) then
   MAX_ERR=0.
   MAX_ERR_RULES=0.
   i_c_ref=0
   str= " "
   do i_d=1,N_m
     call check(ref%M(i_d,:),out%M(i_d,:),i_d==N_m,"Momentum")
   enddo
 endif
 !
 MAX_ERR=0.
 MAX_ERR_RULES=0.
 i_c_ref=0
 str= " "
 do i_d=1,N_data_to_check
   call check(ref%D(i_d,:),out%D(i_d,:),i_d==N_data_to_check,"VALUE")
 enddo
 !
 write (*,'(a)') trim(CHECK_result)
 !
end program find_the_diff
