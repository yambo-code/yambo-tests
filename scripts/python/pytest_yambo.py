#!/usr/bin/env python
import sys
import yaml
import shutil
import string
import random
import argparse
import numpy as np
from pathlib import Path,os
from download_tests import download_test
from misc import getstatusoutput,os_system,run,copy_all_files,read_files_list,check_ypp,check_ypp_sort

"""
Simple python script to test yambo
Author:  C. Attaccalite

Part of the code is copied from scitools of Hans Petter Langtangen 
https://github.com/hplgit/scitools

"""


def get_args():
    # Default parameters
    yambo_dir = ""
    tests_dir = "../../TESTS/MAIN"
    scratch = "."
    yambo_file = "yambo"
    ypp_file = "ypp"
    nprocs = 1
    mpi_launcher = "mpirun"
    tollerance = 0.1
    download_link = 'https://media.yambo-code.eu/robots/databases/tests'
    
    # Parsing configuration file
    infile = Path("config.yaml")
    if infile.is_file():
        with open(infile.name, 'r') as yf:
            config = yaml.safe_load(yf)
    if "yambo_dir" in config["parameters"]: yambo_dir = config["parameters"]["yambo_dir"]
    if "tests_dir" in config["parameters"]: tests_dir = config["parameters"]["tests_dir"]
    if "scratch" in config["parameters"]: scratch = config["parameters"]["scratch"]
    if "yambo_file" in config["parameters"]: yambo_file = config["parameters"]["yambo_file"]
    if "ypp_file" in config["parameters"]: ypp_file = config["parameters"]["ypp_file"]
    if "nprocs" in config["parameters"]: nprocs = config["parameters"]["nprocs"]
    if "mpi_launcher" in config["parameters"]: mpi_launcher = config["parameters"]["mpi_launcher"]
    if "tollerance" in config["parameters"]: tollerance = config["parameters"]["tollerance"]

    # Parsing command line
    parser = argparse.ArgumentParser(prog='pytest_yambo',description='Simple python driver for the yambo-tests',epilog="Copyright Claudio Attaccalite 2019")
    #parser.add_argument('-i',help='input file in json format',metavar='FILE',type=str,dest='infile',default='parameters.json')
    parser.add_argument('-link', help='download link', type=str, dest='link', default=download_link)
    parser.add_argument('-tol',help='tollerance (between 0 - 100%%)',type=float,dest='tollerance',default=tollerance)
    parser.add_argument('-scr',help='scratch directory',type=str,dest='scratch',default=scratch)
    parser.add_argument('-tests',help='tests directory',type=str,dest='tests_dir',default=tests_dir)
    parser.add_argument('-bin',help='yambo bin directory',type=str,dest='yambo_dir',default=yambo_dir)
    parser.add_argument('-mpi',help='mpi launcher',type=str,dest='mpi_launcher',default=mpi_launcher)
    parser.add_argument('-np',help='number of mpi tasks',type=int,dest='nprocs',default=nprocs)
    parser.add_argument('-yambo',help='yambo executable',type=str,dest='yambo_file',default=yambo_file)
    parser.add_argument('-ypp ',help='ypp exectuable',type=str,dest='ypp_file',default=ypp_file)
    parser.add_argument('-skip-run',help='skip runs just compare the results',dest='skiprun',action='store_true')
    parser.add_argument('-skip-comp',help='skip comparison just run the tests',dest='skipcomp',action='store_true')
    parser.add_argument('-del-scratch',help='skip comparison just run the tests',dest='delscratch',action='store_true',default=False)
    parser.set_defaults(skiprun=False)
    parser.set_defaults(skipcomp=False)
    args = parser.parse_args()

    return args, config["tests"]


def check_code():
    print("Checking codes: ")
    try:
        print("Yambo is..."+str(yambo.exists())+"; ", end = '')
        print("Ypp is..."+str(ypp.exists()))
    except:
       print(" KO!\n")
       exit(1)


def check_folders():
    print("Checking codes and foldes: ")
    try:
        print("Test folder is..."+str(test_folder.is_dir())+"; ", end = '')
        print("\nChecking sub-folders: ")
        print("SAVE folder is..."+str(save_dir.is_dir())+"; ", end = '')
        print("SAVE_converted folder is..."+str(save_conv_dir.is_dir())+"; ", end = '')
        print("INPUTS folder is..."+str(inputs_dir.is_dir())+"; ", end = '')
        print("REFERENCE folder is..."+str(reference_dir.is_dir())+"; ")
    except:
       print(" KO!\n")
       exit(1)


def convert_wf():
    print("Convert old WF ===>>> new WF....",end='')
#    program  =str(yambo)
#    options  =""
#    failure=run(program=program,options=options,logfile="conversion_wf.log")
#    program  =str(ypp)
#    options  ="-w c"
#    failure=run(program=program,options=options,logfile="conversion_wf.log")
#    if failure: 
#        print("KO!")   
#        exit(0)
#    else:
#        print("OK")   

#    print("Rename FixSAVE,SAVE ===>>> SAVE, oldSAVE....",end='')
    print("Rename SAVE_converted,SAVE ===>>> SAVE, oldSAVE....",end='')
    try:
        oldSAVE=Path('SAVE')
        oldSAVE.rename('oldSAVE')
        FixSAVE=Path('SAVE_converted')
        FixSAVE.rename('SAVE')
    except:
        print("KO!")
        exit(1)
    print("OK")


def copy_SAVE_and_INPUTS(scratch_dir, test_folder):
    for a_dir in test_folder.iterdir():
        if a_dir.is_dir():
            new_dir=scratch_dir.joinpath(a_dir.name)
            Path(new_dir).mkdir(parents=False,exist_ok=False)
            copy_all_files(a_dir,new_dir)


def make_tmpdir(scratch, run_name, run_type):
    N = 6
    try:
        res = ''.join(random.choices(string.ascii_uppercase+string.ascii_lowercase+string.digits, k=N))
        tmpdir = scratch.joinpath('runtest_{0}_{1}_{2}'.format(run_name,run_type,res))
        tmpdir.mkdir()
    except:
        print("Error creating runtest folder into {}".format(scratch))
        exit(1)
    return tmpdir


# 
# ************* MAIN PROGRAM ********************
#
def main(run_name, run_type):
    if not args.skiprun:
        print("\n\n ********** RUNNING TESTS {}_{} ***********\n\n".format(run_name,run_type))

    #read test list
    tests_list=read_files_list(inputs_dir,noext='',nocontains='_shi')
    print("\nNumber of tests: "+str(len(tests_list)))
    
    # copy SAVE and INPUTS in the SCRATCH directory 
    if not args.skiprun:
        try:
            copy_SAVE_and_INPUTS(scratch_dir, test_folder)
        except:
            print("Error copying SAVE and INPUTS folders to SCRATCH! ")
            exit(1)
    
    # go in the SCRATCH directory
    try:
        os.chdir(str(scratch_dir))
    except:
        print("Run tests to create all the folders!")
        exit(1)
    
    # convert the WF
    if not args.skiprun: convert_wf()    
    
    if not args.skiprun:
        #
        # Run all tests
        #
        for test in tests_list:
            # ************ Running test **************
            print("Running test: "+test.name+"...", end='')
    
            inputfile=Path("INPUTS/"+test.name).as_posix()
    
            if "ypp" in test.name or check_ypp(inputfile):
                # ********* Running ypp **************
                program = str(ypp) + " -nompi"
            elif check_ypp_sort(inputfile):
                # ********* Running ypp **************
                program = str(ypp) + " -nompi -e s -q {}".format(check_ypp_sort(inputfile))
            else:
                # ********** Running Yambo ***********
                if mpi_launcher:
                    program = mpi_launcher + " -n {} ".format(nprocs) + str(yambo)
                else:
                    program = str(yambo)
    
            # ******** Setup actions for the test ******
            actions_file = Path("INPUTS/"+test.name+".actions")
        
            if actions_file.is_file():
                with open(str(actions_file), 'r') as afile:
                    for line in afile:
                        failure, output = os_system(line.rstrip(), verbose=False)

            # ******** Setup flags for the test ******
            flag_file = Path("INPUTS/"+test.name+".flags")
        
            options = " -J "+test.name
            
            if flag_file.is_file():
                with open(str(flag_file),"r") as flag_file:
                    flag=flag_file.read().strip()
                options += ",{}".format(flag)
                #previous_test_dir=Path(flag)
                #new_test_dir     =Path(test.name)
                #Path(new_test_dir).mkdir(parents=True,exist_ok=True)
                #copy_all_files(previous_test_dir,new_test_dir)
    
        # ****** run yambo or ypp *****************
            failure=run(program=program,options=options,inputfile=inputfile,logfile=test.name+".log")
    
            if(failure):
                print("KO!")
                exit(1)
            else:
                print("OK")
    
    if not args.skipcomp:
        print("\n\n ********** COMPARE wiht references ***********\n")
        reference_list=read_files_list(reference_dir,begin='o-')
    
        test_total   =0
        test_ok      =0
        test_failed  =0
        test_nan     =0
        test_notfound=0
    
        log_file=open("tests.log","w")
    
        for ref in reference_list:
            print("CHECK FILE: "+ref.name+"...")
            log_file.write("CHECK FILE: "+ref.name+"...\n")
    
            if '.ndb' in ref.name:
                log_file.write("     database test not implemented yet! \n")
                continue
    
            # Open reference file
            ref_file=reference_dir.joinpath(ref.name).as_posix()
            ref_data=np.genfromtxt(str(ref_file))
    
            # Open test file
            try:
                test_data=np.genfromtxt(ref.name)
            except:
                log_file.write("    file not found!!\n")
                test_notfound += 1
                continue
    
            # Renormalize data to have 1 as maximum
            maxval=np.amax(ref_data[:,1:])
            if maxval==0.0: maxval=1.0
    
            # Compare data column by column
            for col in range(1,ref_data.shape[1]):
               test_total += 1
               log_file.write("     column %d ...." % (col+1))
               if np.any(abs(test_data[:,col])>too_large) or np.any(np.isnan(test_data[:,col])):
                    log_file.write("NaN or too large number! \n")
                    test_nan += 1
                    continue
    
    
               diff=abs(ref_data[:,col]-test_data[:,col])/maxval
               for row in range(ref_data.shape[0]):
                    if abs(ref_data[row,col]/maxval)>zero_dfl:
                       diff[row] = diff[row]/(ref_data[row,col]/maxval)
    
               if np.any(diff>tollerance):
                    log_file.write("Error difference larger than %f! \n" % (tollerance))
                    test_failed +=1
                    continue
               del diff
               test_ok += 1
               log_file.write("OK\n")
    
            del ref_data,test_data
    
        report="\n\n             **** REPORT ****\n"
        report+=" Files not found         : %d \n" % test_notfound
        report+=" Total tests             : %d \n" % test_total
        report+=" Failed tests            : %d \n" % test_failed
        report+=" NaN or too large values : %d \n" % test_nan
        report+=" Tests OK                : %d \n" % test_ok
    
        print(report)
        log_file.write(report)
        log_file.close()


if __name__ == "__main__":
    # SETTING PARAMETERS
    zero_dfl      = 1e-6
    too_large     = 10e99

    args, tests = get_args()
    
    tollerance = float(args.tollerance)
    scratch        = Path(os.path.abspath(args.scratch))
    tests_dir      = Path(os.path.abspath(args.tests_dir))
    yambo_bin      = Path(os.path.abspath(args.yambo_dir)) if args.yambo_dir else None 
    yambo          = yambo_bin.joinpath(args.yambo_file) if yambo_bin else Path(shutil.which(args.yambo_file))
    ypp            = yambo_bin.joinpath(args.ypp_file) if yambo_bin else Path(shutil.which(args.ypp_file))
    mpi_launcher   = args.mpi_launcher
    nprocs         = args.nprocs
    
    print("\n * * * Yambo python tests * * * \n\n")
    
    if sys.version_info[0] < 3:
        raise Exception("Must be using Python 3")
    
    check_code()

    for run_name, runs in tests.items():
        for run_type in runs:
            download_test(run_name, run_type, args.link, str(tests_dir))
            scratch_dir  = make_tmpdir(scratch, run_name, run_type) #used to run the tests
            test_folder  = tests_dir.joinpath(run_name).joinpath(run_type)
            inputs_dir   = test_folder.joinpath("INPUTS")
            save_dir     = test_folder.joinpath("SAVE")
            save_conv_dir= test_folder.joinpath("SAVE_converted")
            reference_dir= test_folder.joinpath("REFERENCE")
            check_folders()
            main(run_name, run_type)
            
