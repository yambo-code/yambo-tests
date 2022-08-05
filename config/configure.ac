#
#        Copyright (C) 2000-2019 the YAMBO team
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
AC_MSG_CHECKING([the robot name])
AC_ARG_WITH(host, AC_HELP_STRING([--with-host=<HOST>],[User-defined HOST],[32]),[],[with_host="$robot"]) 
robot="$with_host"
if test -f .running_robot.pl; then
 robot=`head -n 1 .running_robot.pl | cut -d '=' -f 2 | sed "s/'//g" | sed "s/;//g"`
fi
AC_MSG_RESULT($robot)
AC_MSG_CHECKING([the $robot/$user configuration])
if test -d ROBOTS/$robot && test -d ROBOTS/$robot/$user/CONFIGURATIONS && test -d ROBOTS/$robot/$user/FLOWS; then
 AC_MSG_RESULT(found)
else
 AC_MSG_RESULT(created)
 mkdir -p ROBOTS/$robot/$user
 echo '$'"ROBOTS{'"$hostname"'} = '"$robot"';" >> ROBOTS/ROBOTS_list.pl
fi
if ! test -d ROBOTS/$robot/$user/SCRIPTS; then
  mkdir -p ROBOTS/$robot/$user/SCRIPTS
fi
if ! test -f ROBOTS/$robot/$user/CRONTAB; then
  cp config/SAMPLE_crontab  ROBOTS/$robot/$user/CRONTAB
fi
if ! test -d ROBOTS/$robot/$user/CPU_CONFIGURATIONS; then
 AC_MSG_NOTICE(Filling $robot/$user/CPU_CONFIGURATIONS)
 mkdir -p ROBOTS/$robot/$user/CPU_CONFIGURATIONS/
 cp config/SAMPLE_conf.cpu    ROBOTS/$robot/$user/CPU_CONFIGURATIONS/
fi
if ! test -d ROBOTS/$robot/$user/CONFIGURATIONS; then
 AC_MSG_NOTICE(Filling $robot/$user/CONFIGURATIONS)
 mkdir -p ROBOTS/$robot/$user/CONFIGURATIONS/
 cp config/SAMPLE_config.sh   ROBOTS/$robot/$user/CONFIGURATIONS/default.sh
fi
if ! test -d ROBOTS/$robot/$user/FLOWS; then
 AC_MSG_NOTICE(Filling $robot/$user/FLOWS)
 mkdir -p ROBOTS/$robot/$user/FLOWS/
 cp config/SAMPLE_flow.pl     ROBOTS/$robot/$user/FLOWS/default.pl
 cp config/SAMPLE_validate.pl ROBOTS/$robot/$user/FLOWS/validate.pl
fi
AC_SUBST(user)
AC_SUBST(robot)
AC_SUBST(hostname)
# ============================================================================
# TOOLS
# ncftp/ncftpls/ncftpput
AC_ARG_ENABLE(ftp, AC_HELP_STRING([--enable-ftp],[Stick to standard FTP rather then SFTP. Default is no.]))
#
AC_ARG_WITH(ncftp, AC_HELP_STRING([--with-ncftp=<exe>],[User-defined ncftp],[32]),[],[with_ncftp="ncftp"]) 
AC_ARG_WITH(ncftpls, AC_HELP_STRING([--with-ncftpls=<exe>],[User-defined ncftpls],[32]),[],[with_ncftpls="ncftpls"]) 
AC_ARG_WITH(ncftpput, AC_HELP_STRING([--with-ncftpput=<exe>],[User-defined ncftpput],[32]),[],[with_ncftpput="ncftpput"]) 
if ! test x"$enable_ftp" = "x"; then
 AC_CHECK_PROGS(ncftp,[$with_ncftp],[none])
 AC_CHECK_PROGS(ncftpls,[$with_ncftpls],[none])
 AC_CHECK_PROGS(ncftpput,[$with_ncftpput],[none])
else
 ncftp="none";
 ncftpls="none";
 ncftpput="none";
fi
AC_SUBST(ncftp)
AC_SUBST(ncftpls)
AC_SUBST(ncftpput)
# wget
AC_ARG_WITH(wget, AC_HELP_STRING([--with-wget=<exe>],[User-defined wget],[32]),[],[with_wget="wget"]) 
AC_CHECK_PROGS(wget,[$with_wget],[none])
AC_SUBST(wget)
# git
AC_ARG_WITH(git, AC_HELP_STRING([--with-git=<exe>],[User-defined git],[32]),[],[with_git="git"]) 
AC_CHECK_PROGS(git,[$with_git],[none])
if test $git = "none"; then AC_MSG_ERROR([Please provide the path to a working git]); fi
AC_SUBST(git)
# awk
AC_ARG_WITH(awk, AC_HELP_STRING([--with-awk=<exe>],[User-defined awk],[32]),[],[with_awk="awk"]) 
AC_CHECK_PROGS(awk,[$with_awk],[none])
if test $awk = "none"; then AC_MSG_ERROR([Please provide the path to a working awk]); fi
AC_SUBST(awk)
# txt2html
AC_ARG_WITH(txt2html, AC_HELP_STRING([--with-txt2html=<exe>],[User-defined txt2html],[32]),[],[with_txt2html="txt2html"]) 
AC_CHECK_PROGS(txt2html,[$with_txt2html],[none])
AC_SUBST(txt2html)
# rsync
AC_ARG_WITH(rsync, AC_HELP_STRING([--with-rsync=<exe>],[User-defined rsync],[32]),[],[with_rsync="rsync"]) 
AC_CHECK_PROGS(rsync,[$with_rsync],[none])
if test $rsync = "none"; then AC_MSG_ERROR([Please provide the path to a working rsync]); fi
# ============================================================================
# COMPILATION MODULES
#
if ! test -f ROBOTS/$robot/$user/MODULES; then
 AC_MSG_NOTICE(Filling $robot/$user/MODULES)
 cp config/SAMPLE_modules ROBOTS/$robot/$user/MODULES
else
 AC_MSG_RESULT(found an existing MODULES file)
fi
#
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
   source_dir=`head -n 1 ROBOTS/$robot/$user/BRANCHES| sed 's/#//' | cut -d ' ' -f 1`
   ;;
  *) 
   if test -f ROBOTS/$robot/$user/BRANCHES; then
     GREP=`grep $with_yambo ROBOTS/$robot/$user/BRANCHES |wc -l`
     if ! test x"$GREP" = "x0"; then 
      if test -f $with_yambo/driver/yambo.F ; then
        AC_MSG_RESULT($with_yambo)
        echo "$with_yambo" >> ROBOTS/$robot/$user/BRANCHES
      else
        AC_MSG_ERROR([could not locate the Yambo source])
      fi
     else
      AC_MSG_RESULT($with_yambo already in the BRANCHES file)
     fi
   else
     if test -f $with_yambo/driver/yambo.F ; then
       AC_MSG_RESULT($with_yambo)
       echo "$with_yambo" >> ROBOTS/$robot/$user/BRANCHES
     fi
   fi
   source_dir=$with_yambo
    ;;
esac
AC_SUBST(source_dir)
#
# ... libraries
#
AC_ARG_WITH(yambo_libs, AC_HELP_STRING([--with-yambo-libs=<path>],[Path to the folder where the test-suite will install the Yambo ext-libs],[32]))
if test "$with_yambo_libs" = ""; then with_yambo_libs="none"; fi
if test -f .running_robot.pl; then
 with_yambo_libs=`tail -n 1 .running_robot.pl | cut -d '=' -f 2 | sed "s/'//g" | sed "s/;//g"`
fi
echo '$'"host='"$robot"';" > .running_robot.pl
echo '$'"ext_libs_path='"$with_yambo_libs"';" >> .running_robot.pl
# ============================================================================
# System specific setups
case "${host}" in
 *86*apple* )
   grep_cmd="grep -P"
   NP_cmd="sysctl hw.physicalcpu"
   ;;
  *)
   grep_cmd="grep"
   NP_cmd="\$grep -c -P '^processor\\\\s+:' /proc/cpuinfo"
   ;;
 *)
esac
AC_SUBST(NP_cmd)
AC_SUBST(grep_cmd)
#
# ============================================================================
# Credentials setup
#
git config credential.helper store
#
# ============================================================================
# PERL_LIB
#
test_suite_dir=`pwd`	
PERL_LIB="${test_suite_dir}/libs"
AC_SUBST(test_suite_dir)
AC_SUBST(PERL_LIB)
# ============================================================================
AC_CONFIG_FILES([config/MODULES.pl config/TOOLS.pl scripts/branch_continuous_testing.tcsh scripts/reset.sh scripts/test-suite-launcher.tcsh])
AC_OUTPUT
chmod ug+x scripts/*sh
