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
