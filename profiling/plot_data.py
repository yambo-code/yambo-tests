#! /usr/bin/env python3

import os
import sys
import numpy as np
import matplotlib.pyplot as plt
#from scipy.interpolate import interp1d
#from scipy.interpolate import CubicSpline

def print_usage():
   usage = "\n"
   usage+= "plot_data.py [-h,--help] [-q,--quiet] [-p <fileout>]   <filedat> \n"
   usage+= "\n"
   usage+= "   -h, --help     print this help \n"
   usage+= "   -q, --quiet    silent execution (no plot window) \n"
   usage+= "   -p <fileout>   dump plot data to fileout [png/pdf fmts permitted] \n"
   usage+= "   <filedat>      file containing the data to be plot \n"
   usage+= "                  (two columns, # comments)"
   usage+= "\n"
   print(usage)

def main(argv):
  """
  plot given data
  """
  filedat=""
  fileout=""
  do_plot=True
  #
  for arg in argv[1:]:
     #print("arg = ",arg)
     #
     if arg == "-h" or arg == "--help":
        print_usage()
        sys.exit(0)
     elif arg == "-q" or arg == "--quiet":
        do_plot=False
        ind=argv.index("-q")
        if ind==0: ind=argv.index("--quiet")
        argv.pop(ind)
     elif arg == "-p":
        ind=argv.index("-p")
        if len(argv) <= ind+1:
           print_usage()
           sys.exit(1)
        fileout=argv[ind+1]
        argv.pop(ind)
        argv.pop(ind)

  if (len(argv)>2 or len(argv)==1):
     print_usage()
     sys.exit(2)

  filedat=argv[1]
  
  #
  # read data
  #
  data=np.loadtxt(filedat)
  xl=data[:,0]
  yl=data[:,1]
  #
  # get labels
  #
  labelx="xvar"
  labely="yvar"
  #
  f=open(filedat,"r")
  for line in f:
     if "legend" in line or "LEGEND" in line:
        newline=f.readline().replace("#","")
        labelx=newline.split("&")[0]
        labely=newline.split("&")[1]
  f.close()

  ##
  ## interpolation with cubic spline, if needed
  ##
  #fint=interp1d(xl, yl, kind='cubic')
  #xmin=min(xl)
  #xmax=max(xl)
  #nx=1001
  #xint=np.linspace(xmin,xmax,num=nx,endpoint=True)
  #yint=fint(xint)

  #
  # plot data
  #
  plt.plot(xl,yl,"ro-")
  #plt.plot(xl,yl,"ro",xint,yint,"g")
  plt.xlabel(labelx)
  plt.ylabel(labely)
  #
  if len(fileout)>0 : plt.savefig(fileout)
  if do_plot :        plt.show()


if __name__ == "__main__":
   main(sys.argv)


def readin_alt():
  fl=open(filedat,'r')
  xl=[]
  yl=[]
  for line in fl:
    xl.append(line.split()[0])
    yl.append(line.split()[1])
  fl.close()
  return xl,yl

