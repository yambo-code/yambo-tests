#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# This file is distributed under the terms of the GNU
# General Public License. You can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
#
# This program is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place - Suite 330,Boston,
# MA 02111-1307, USA or visit http://www.gnu.org/copyleft/gpl.txt.
#
AC_INIT(driver.pl, 5.0, yambo@yambo-code.org)
#
AC_CONFIG_AUX_DIR([config])
#
# ============================================================================
# ROBOT setup
AC_CANONICAL_HOST
domainame=`domainname -d`
hostname=`uname -n`
username=`whoami`
robot="$hostname"
user="$username"
if test "$domainame" != ""; then robot="$hostname.$domainame"; fi
AC_MSG_CHECKING([the $robot/$user ROBOT])
if test -d ROBOTS/$robot && test -d ROBOTS/$robot/$user/CONFIGURATIONS && test -d ROBOTS/$robot/$user/FLOWS; then
 AC_MSG_RESULT(found)
else
 AC_MSG_RESULT(created)
 mkdir -p ROBOTS/$robot/$user
 mkdir -p ROBOTS/$robot/$user/CONFIGURATIONS/
 mkdir -p ROBOTS/$robot/$user/FLOWS/
 cp config/SAMPLE_config.sh   ROBOTS/$robot/$user/CONFIGURATIONS/default.sh
 cp config/SAMPLE_flow.pl     ROBOTS/$robot/$user/FLOWS/default.pl
 cp config/SAMPLE_validate.pl ROBOTS/$robot/$user/FLOWS/validate.pl
 touch ROBOTS/$robot/$user/TIME_ID
 svn --force add ROBOTS/$robot/
 svn --force add ROBOTS/$robot/$user/
 echo "$robot" >> .gitignore
fi
AC_SUBST(user)
AC_SUBST(robot)
AC_SUBST(hostname)
# ============================================================================
# TOOLS
# ncftp/ncftpls/ncftpput
with_ncftp="ncftp"
AC_ARG_WITH(ncftp, AC_HELP_STRING([--with-ncftp=<exe>],[User-defined ncftp],[32]),[],[with_ncftp="ncftp"]) 
AC_CHECK_PROGS(ncftp,[$with_ncftp],[none])
AC_SUBST(ncftp)
with_ncftpls="ncftpls"
AC_ARG_WITH(ncftpls, AC_HELP_STRING([--with-ncftpls=<exe>],[User-defined ncftpls],[32]),[],[with_ncftpls="ncftpls"]) 
AC_CHECK_PROGS(ncftpls,[$with_ncftpls],[none])
AC_SUBST(ncftpls)
with_ncftpput="ncftpput"
AC_ARG_WITH(ncftpput, AC_HELP_STRING([--with-ncftpput=<exe>],[User-defined ncftpput],[32]),[],[with_ncftpput="ncftpput"]) 
AC_CHECK_PROGS(ncftpput,[$with_ncftpput],[none])
AC_SUBST(ncftpput)
# git
with_git="git"
AC_ARG_WITH(git, AC_HELP_STRING([--with-git=<exe>],[User-defined git],[32]),[],[with_git="git"]) 
AC_CHECK_PROGS(git,[$with_git],[none])
AC_SUBST(git)
# awk
with_awk="awk"
AC_ARG_WITH(awk, AC_HELP_STRING([--with-awk=<exe>],[User-defined awk],[32]),[],[with_awk="awk"]) 
AC_CHECK_PROGS(awk,[$with_awk],[none])
if test $awk = "none"; then AC_MSG_ERROR([Please provide the path to a working awk]); fi
AC_SUBST(awk)
# txt2html
with_txt2html="txt2html"
AC_ARG_WITH(txt2html, AC_HELP_STRING([--with-txt2html=<exe>],[User-defined txt2html],[32]),[],[with_txt2html="txt2html"]) 
AC_CHECK_PROGS(txt2html,[$with_txt2html],[none])
AC_SUBST(txt2html)
# rsync
with_rsync="rsync"
AC_ARG_WITH(rsync, AC_HELP_STRING([--with-rsync=<exe>],[User-defined rsync],[32]),[],[with_rsync="rsync"]) 
AC_CHECK_PROGS(rsync,[$with_rsync],[none])
if test $rsync = "none"; then AC_MSG_ERROR([Please provide the path to a working rsync]); fi
# ============================================================================
# YAMBO
#
AC_ARG_WITH(yambo, AC_HELP_STRING([--with-yambo=<path>],[Path to the yambo source to test],[32]))
AC_MSG_CHECKING([the Yambo source])
case $with_yambo in
  "") 
   if test ! -f ROBOTS/$robot/$user/BRANCHES; then
     AC_MSG_ERROR([Please provide the path to the Yambo source using the --with-yambo=<PATH> option])
   fi
   AC_MSG_RESULT(found an existing BRANCHES file)
   ;;
  *) 
    if test -f ROBOTS/$robot/$user/BRANCHES; then
      GREP=`grep $with_yambo ROBOTS/$robot/$user/BRANCHES |wc -l`
      if ! test x"$GREP" = "x0"; then 
       if test -f $with_yambo/driver/yambo.h ; then
         AC_MSG_RESULT($with_yambo)
         echo "$with_yambo" >> ROBOTS/$robot/$user/BRANCHES
       else
         AC_MSG_ERROR([could not locate the Yambo source])
       fi
      else
       AC_MSG_RESULT($with_yambo already in the BRANCHES file)
      fi
    else
      if test -f $with_yambo/driver/yambo.h ; then
         AC_MSG_RESULT($with_yambo)
         echo "$with_yambo" >> ROBOTS/$robot/$user/BRANCHES
         svn --force add ROBOTS/$robot/$user/BRANCHES
      fi
    fi
    ;;
esac
# ============================================================================
# PERL_LIB
#
PERL_LIB=`pwd`	
PERL_LIB="${PERL_LIB}/libs"
AC_SUBST(PERL_LIB)
# ============================================================================
AC_CONFIG_FILES([config/MODULES.pl config/TOOLS.pl])
AC_OUTPUT
