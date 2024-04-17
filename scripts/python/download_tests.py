#!/usr/bin/env python
import tarfile
import argparse
import subprocess
from pathlib import Path, os


def get_args():
    test_main = '../../TESTS/MAIN'
    download_link = 'https://media.yambo-code.eu/robots/databases/tests'
    parser = argparse.ArgumentParser()
    parser.add_argument('-test', help='test directory', type=str, dest='test_main', default=test_main)
    parser.add_argument('-link', help='download link', type=str, dest='link', default=download_link)
    args = parser.parse_args()
    args.test_main = os.path.abspath(args.test_main)
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


def download_test(test, download_link, test_main):
    test_dir = Path(test_main) / test['name']
    tar_name = test['name'] + "_" + test['run'] + ".tar.gz"

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

    if not Path(test['run']+'/SAVE/ns.wf').exists():
        with tarfile.open(tar_name) as tar:
            tar.extractall(filter='data')

    
if __name__ == '__main__':
    args = get_args()

    tests = [
        {'name':'Al_bulk', 'run':'GW-OPTICS'},
        {'name':'Si_bulk', 'run':'GW-OPTICS'},
        {'name':'LiF', 'run':'GW-OPTICS'},
        {'name':'hBN', 'run':'GW-OPTICS'},
        ]

    for test in tests:
        download_test(test, args.link, args.test_main)

