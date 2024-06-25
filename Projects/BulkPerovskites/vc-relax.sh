#!/bin/sh
####################################################
# This is a sample script to run vc-relax total-energy
# calculations on a unit cell of ABX3 perovskites using five 
# different values for the input parameter 
# 'lattice constant' .
#
# You should copy this file and modify it as 
# appropriate for the tutorial.
####################################################
# Notes:
#
# 1. You can loop over a variable by using the 
#    'for...do...done' construction. As an example, 
#    this code loops over three different values
#    of ecut (5, 10, 15), designated by a
#    variable called CUTOFF.
# 2. Variables can be referred to within the script 
#    by typing the variable name preceded by the '$' 
#    sign. So whenever $CUTOFF appears in the 
#    script, it will be replaced by its current 
#    value.
#
####################################################
# Important initial variables for the code
# (change these as necessary)
####################################################


cat>./test.in<<EOF
5.5
5.6
5.7
5.8
5.9
EOF


for a in $(cat ./test.in); do
cat>./vc-relax.$a.in<<EOF
&CONTROL
calculation='vc-relax'
restart_mode='from_scratch' 
pseudo_dir='./'
outdir='./temp'
!max_seconds=3600
/
&SYSTEM
ibrav=0, nat=5, ntyp=3
occupations='smearing'
smearing='methfessel-paxton'
degauss=0.01
ecutwfc=50.0
ecutrho=300.0
/
&ELECTRONS
conv_thr=1.0d-6
/
&IONS
ion_dynamics='bfgs'
/
&CELL
/
ATOMIC_SPECIES
Cs	132.90545     Cs.pbe-spn-rrkjus_psl.1.0.0.UPF
Pb	207.2         Pb.pbe-dn-rrkjus_psl.1.0.0.UPF
Cl	35.453        Cl.pbe-nl-rrkjus_psl.1.0.0.UPF 
CELL_PARAMETERS (angstrom)
$a  0.00  0.00
0.00  $a  0.00
0.00  0.00  $a
ATOMIC_POSITIONS (crystal)
Cs            0.0000000000        0.0000000000        0.0000000000
Pb            0.5000000000        0.5000000000        0.5000000000
Cl            0.0000000000        0.5000000000        0.5000000000
Cl            0.5000000000        0.0000000000        0.5000000000
Cl            0.5000000000        0.5000000000        0.0000000000
K_POINTS AUTOMATIC
4 4 4 0 0 0
EOF
mpirun -np 32 pw.x < vc-relax.$a.in > ./vc-relax.$a.out
done

## Analysis scripts
# To obtain the global minima of the structure, we need to compare the lattice parameters and their corresponding total energy given in the vc-relax output files.
# The output lattice constant and energy values can be extracted and plotted using below script.

for a in $(cat ./test.in); do
grep "!    total energy              =" ./vc-relax.$a.out  

grep "End final coordinates" ./vc-relax.$a.out  > ./1.dat

