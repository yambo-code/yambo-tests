#!/usr/bin/env python
import tarfile
import argparse
import subprocess
from pathlib import Path, os


def get_args():
    tests_dir = '../../TESTS/MAIN'
    download_link = 'https://media.yambo-code.eu/robots/databases/tests'
    parser = argparse.ArgumentParser()
    parser.add_argument('-test', help='test directory', type=str, dest='tests_dir', default=tests_dir)
    parser.add_argument('-link', help='download link', type=str, dest='link', default=download_link)
    args = parser.parse_args()
    args.tests_dir = os.path.abspath(args.tests_dir)
    return args


def wget(wargs, verbose=False):
    cmd = "wget " + wargs
    process = subprocess.Popen(
        cmd,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,
        text = True,
        shell = True
    )
    std_out, std_err = process.communicate()
    if verbose:
        print(std_out.strip(), std_err)
    pass


def download_test(name, run_type, download_link, tests_dir):
    test_dir = Path(tests_dir) / name
    tar_name = name + "_" + run_type + ".tar.gz"

    try:
        os.chdir(str(test_dir))
        print("LOG: moved to {:s}".format(test_dir.name))
    except:
        print("ERROR: not able to find test directory {:s}".format(test_dir.name))
        exit(1)

    if Path(tar_name).exists():
        print("LOG: file {:s} already available".format(tar_name))
    else:
        print("LOG: downloading file {:s}".format(tar_name))
        wget(download_link+'/'+tar_name, verbose=False)

    if not Path(run_type+'/SAVE/ns.wf').exists():
        with tarfile.open(tar_name) as tar:
            tar.extractall(filter='data')

    
if __name__ == '__main__':
    args = get_args()

    tests = {
	"Al_bulk": ["GW-OPTICS"],
	"Si_bulk": ["GW-OPTICS"],
	"hBN": ["GW-OPTICS"],
	"LiF": ["GW-OPTICS"]
    }

    for name, runs in tests.items():
        for run_type in runs:
            download_test(name, run_type, args.link, args.tests_dir)

