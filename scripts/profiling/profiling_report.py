import os
import re
import argparse
import numpy as np
from matplotlib import colors as mcolors
import matplotlib.pyplot as plt

new_colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728',
              '#9467bd', '#8c564b', '#e377c2', '#7f7f7f',
              '#bcbd22', '#17becf']

size_conv = {'gb':1024**2,
             'kb':1,
             'mb':1024}

time_conv = {'m': 60,
             's': 1,
             'h': 3600}


def list_subdirs(path):
    return next(os.walk(path))[1]
    #return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])

def color_getter():
    for i in range(9):
        yield new_colors[i]
       
 
class YamboTestSuiteRun():
    """
    Class to read all the data inside each test and plot
    """
    def __init__(self,root):
        self.root = root
        walker = os.walk(root) 

        #read the total time
        self.total_time = np.loadtxt('%s/TOTAL_TIME_vs_PAR_CONF.dat'%root,unpack=True)

        #read the folders inside PROFILING folder
        subdirs = next(walker)[1]
       
        memory_time = {}
        time_section = {}

        for a,b,c in walker:
            #get configuration
            par_config = os.path.basename(a)

            memory_time_par = {}
            time_section_par = {}
            
            #get files
            for filename in c:
                data_filename = os.path.join(a,filename)

                if 'MEMORY_vs_TIME' in data_filename:
                    memory_time_par[filename] = np.loadtxt(data_filename)

                if 'TIME_vs_SECTION' in data_filename:
                    with open(data_filename,'r') as f:
                        sections = {}
                        for line in f.readlines():
                            section, time = line.split()
                            sections[section] = float(time)
                        time_section_par[filename] = sections

            time_section[par_config] = time_section_par
            memory_time[par_config] = memory_time_par

        #save
        self.time_section = time_section
        self.memory_time = memory_time

    def plot_time_cpu(self,ax=plt):
        """
        Plot total runtime vs cpu
        """
        cpus, time = self.total_time
        ax.plot( cpus, time )
        ax.title(self.root)
        ax.xlabel('ncpus')
        ax.ylabel('time (s)')
        ax.savefig('TOTAL_TIME_vs_PAR_CONF.pdf')
        ax.clf()

    def plot_memory_time(self,ax=plt,size='mb',time='s'):
        """
        Plot memory as a function of time
        """
      
        get_color = color_getter() 
        for key,cpus in list(self.memory_time.items()):
            color = next(get_color)
            for cpu,data in list(cpus.items()):
                sec_time, memory = data.T
                line, = ax.plot(sec_time/time_conv[time],memory/size_conv[size],c=color)
            line.set_label(key) 

        ax = plt.gca()
        box = ax.get_position()
        ax.set_position([box.x0, box.y0, box.width * 0.7, box.height])

        plt.legend(frameon=False,loc='center left', bbox_to_anchor=(1, 0.5))
        plt.xlabel('time (%s)'%time)
        plt.ylabel('memory (%s)'%size)
        plt.savefig('MEMORY_vs_TIME.pdf')
        plt.clf()

    def plot_time_section(self,size=4,figsize=4,time='s',verbose=False):
        """
        Plot section timing vs CPU
        """
        #get all sections
        sections = set()
        for cpu in list(self.time_section.values()):
            for i in list(cpu.values()):
                for section in list(i.keys()):
                    sections.add(section)
        sections_colors = dict(list(zip(sections,color_getter())))
        nparalel_configs = len(self.time_section)

        sorted_cpus = sorted( self.time_section.items(), key=lambda x: len(x[1]) )
        #create subplots
        fig = plt.figure(figsize=(figsize*len(sorted_cpus),figsize))

        one_artist_per_section = {}
        for n,(key,cpus) in enumerate(sorted_cpus):
        
            if verbose: print(key)
        
            #create subplots
            ax = plt.subplot(1, nparalel_configs, n+1)

            #for each number of cpus
            for cpu,data in cpus.items():
                if verbose: print(" "*5,cpu)
                ncpu = int(re.findall('[0-9]+',cpu)[0])
                ordered_section_times = sorted(data.items(),key=lambda x: x[1],reverse=True)

                #for each section
                for section, sec_time in ordered_section_times:
                    bar, = ax.bar(ncpu,sec_time/time_conv[time],
                                  color=sections_colors[section],align='center')
                    one_artist_per_section[section] = bar
                    if verbose: print(" "*10, section,time)
            

            ax.set_title(key)
            ax.set_xticks(range(1,len(cpus)+1))
            ax.set_ylabel('time (%s)'%time)

        plt.subplots_adjust( left=0.1, wspace=0.3, right=0.8 )
        #add legend
        for section,artist in list(one_artist_per_section.items()):
            artist.set_label(section)
        ax.legend(handles=list(one_artist_per_section.values()),frameon=False,
                  loc='center left', bbox_to_anchor=(1, 0.5))
        fig.savefig("TIME_vs_SECTION.pdf")

    def __str__(self):
        s = self.root
        s += "".join(["\n  "+x for x in list(self.time_section.keys())])
        return s


class Profiling():
    """
    Class to read the profiling information from the yambo test suite
    """
    def __init__(self,root):
        #read the folders inside PROFILING folder
        for a in list_subdirs(root):
            test = os.path.basename(a)
            print(test)
            for test in list_subdirs(a):
                subtest = os.path.basename(test)
                print(" "*5,subtest)
                for par in list_subdirs(test):
                    conf = os.path.basename(par)
                    print(" "*10,conf)
  

if __name__ == "__main__":

    #parse options
    parser = argparse.ArgumentParser(description='Plot timing yambo test suite.')
    parser.add_argument('root', help='root where to find the files')
    args = parser.parse_args()

    r = YamboTestSuiteRun(args.root)
    print(r)
  
    #plot1 
    ax = r.plot_time_cpu()

    #plot2
    ax = r.plot_memory_time(time='s',size='mb')

    #plot3
    ax = r.plot_time_section(time='m')


