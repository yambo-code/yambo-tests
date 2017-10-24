#!/bin/sh

cat << EOF >> Makefile
f_objs = module.o routines.o data.o check.o RULES.o find_the_diff.o
find_the_diff : \$(f_objs)
	@eval \$(fc) \$(f90flags) -I\$(includedir) -o \$@ \$(f_objs)
clean:
	@rm -f \$(f_objs) diff.mod
#
# Suffixes
#
.SUFFIXES: .F .f90 .o
#
# Rules
#
.F.o:
	@rm -f \$*\$(f90suffix)
	@eval \$(fpp) \$(dopts) \$*.F > \$*\$(f90suffix)
	@eval \$(fc) -c \$(f90flags) -I\$(includedir) \$*\$(f90suffix)
	@rm -f \$*\$(f90suffix)
EOF

make
