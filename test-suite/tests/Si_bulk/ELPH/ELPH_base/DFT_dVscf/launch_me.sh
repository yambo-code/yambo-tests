#!/bin/bash
../../../scripts/PW_el-ph_driver.tcsh ../DFT_commons/q-list ../DFT_commons/Si.tcsh 4 4 4 10 n
find . -name '*dvscf*' -o -name '*dyn' | zip -@ ../dVscf.zip
