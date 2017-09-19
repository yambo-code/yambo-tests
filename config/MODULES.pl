#!/usr/bin/perl
#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# Based on the original driver written by CH
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
#
use lib "/home/sangalli/data/Lavoro/Codici/yambo/yambo-tests/libs";
#
#  SYSTEM
#
use Getopt::Long;
use File::Find;
use File::Spec;
use File::Copy;
use File::Basename;
use File::Path 'rmtree';
use Cwd 'abs_path';
use Time::HiRes qw(gettimeofday tv_interval);   # Not widely supported
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
# MAIN driver
use driver;
# COMMONS
use UTILS_time;
use UTILS_download;
use UTILS_clean;
use UTILS_commit;
use UTILS_backup;
use UTILS_input_tests;
use UTILS;
use UTILS_title;
use UTILS_list_tests;
use UTILS_options_and_usage;
use UTILS_failed_theme_creator;
use UTILS_update;
use UTILS_upload;
# Messages
use MESSAGE;
use MY_PRINT;
# FTP
use FTP_utils;
# SETUP
use SETUP;
use SETUP_keys;
use SETUP_defaults;
use SETUP_branch;
use SETUP_build;
use SETUP_FC_kind;
use SETUP_configuration;
# FLOWS
use FLOWS;
# COMPILE
use COMPILE_find_the_diff;
# RUN
use RUN_get_runlevels;
use RUN_input_utils;
use RUN_input_file_test;
use RUN_driver;
use RUN_global_report;
use RUN_logs;
use RUN_executables;
use RUN_restore_the_SAVE;
use RUN_convert_the_SAVE;
use RUN_skip_the_test;
use RUN_load_conf;
use RUN_load_actions;
use RUN_load_PAR_fields;
use RUN_random_PAR;
use RUN_user_flags;
use RUN_setup;
use RUN_it;
use RUN_stats;
use RUN_PAR_constrains;
#
# CHECKS
use CHECK_exist;
use CHECK_file;
use CHECK_driver;
use CHECK_database;
use CHECK_GPL_skip;
#

