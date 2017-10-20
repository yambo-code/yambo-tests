import os
import re
import numpy as np
from matplotlib import colors as mcolors
import matplotlib.pyplot as plt

def list_subdirs(path):
    return next(os.walk(path))[1]
    #return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])

def color_getter():
    for i in range(9):
        yield 'C%d'%i
       
 
class Run():
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

    def plot_memory_time(self,ax=plt,unit='mb'):
        """
        Plot memory as a function of time
        """

       
        unit_conv = {'gb':1024**2,
                     'kb':1,
                     'mb':1024}[unit]

        get_color = color_getter() 
        for key,cpus in self.memory_time.items():
            color = get_color.next()
            for cpu,data in cpus.items():
                time, memory = data.T
                line, = ax.plot(time,memory/unit_conv,c=color)
            line.set_label(key) 
        ax.legend()
        ax.xlabel('time (s)')
        ax.ylabel('memory (%s)'%unit)
        ax.savefig('MEMORY_vs_TIME.pdf')
        ax.clf()

    def plot_time_section(self,size=4,verbose=False):
        """
        Plot section timing vs CPU
        """
        #get all sections
        sections = set()
        for cpu in self.time_section.values():
            for i in cpu.values():
                for section in i.keys():
                    sections.add(section)
        sections_colors = dict(zip(sections,color_getter()))
        nparalel_configs = len(self.time_section)

        #create subplots
        fig = plt.figure(figsize=(size*4,size))

        for n,(key,cpus) in enumerate(self.time_section.items()):
        
            if verbose: print key
        
            #create subplots
            ax = plt.subplot(1, nparalel_configs, n+1)

            #for each number of cpus
            one_artist_per_section = {}
            for cpu,data in cpus.items():
                if verbose: print " "*5,cpu
                ncpu = int(re.findall('[0-9]+',cpu)[0])
                ordered_section_times = sorted(data.items(),key=lambda x: x[1],reverse=True)

                #for each section
                for section, time in ordered_section_times:
                    bar, = ax.bar(ncpu,time,color=sections_colors[section])
                    one_artist_per_section[section] = bar
                    if verbose: print " "*10, section,time
            
            #add legend
            for section,artist in one_artist_per_section.items():
                artist.set_label(section)

            ax.set_title(key)
            plt.legend()
        fig.savefig("TIME_vs_SECTION.pdf")

    def __str__(self):
        s = self.root
        s += "".join(["\n  "+x for x in self.time_section.keys()])
        return s


class Profiling():
    """
    Class to read the profiling information from the yambo test suite
    """
    def __init__(self,root):
        #read the folders inside PROFILING folder
        for a in list_subdirs(root):
            test = os.path.basename(a)
            print test
            for test in list_subdirs(a):
                subtest = os.path.basename(test)
                print " "*5,subtest
                for par in list_subdirs(test):
                    conf = os.path.basename(par)
                    print " "*10,conf
  

if __name__ == "__main__":
    root = 'PROFILING' 

    r = Run('PROFILING/Al_bulk_GW-OPTICS/02_Lifetimes')
    print r
  
    #plot1 
    ax = r.plot_time_cpu()

    #plot2
    ax = r.plot_memory_time(unit='mb')

    #plot3
    ax = r.plot_time_section()


