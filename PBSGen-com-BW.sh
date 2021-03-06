# Generating multiple PBS files with each multiple parallel simulations for sumission on Blue Waters using shell script

jobname=FLS
cat >  PBS_${jobname} << EOF
#PBS -l nodes=30:ppn=1:xk
#PBS -l walltime=48:00:00
#PBS -N ${jobname}
#PBS -e ${jobname}.err
#PBS -o ${jobname}.out
#PBS -q low
#PBS -A jt3
cd ${path}
EOF

# sys1
iName=MD
r=2 #Sampling round
a=0 #input index
b=1 #output index
Path=/u/sciteam/shamsi/fls2/MD/fls
iPath=/u/sciteam/shamsi/fls2/MD
pPath=${Path}/MD${r}
cPath=${Path}/MD${r}/MD${r}-${a}
orPath=${Path}/MD${r}/MD${r}-${b}
path=${Path}/MD${r}/MD${r}-${b}
mkdir ${orPath}
while read line
do
  echo "aprun -n 1 -N 1 pmemd.cuda -O -i ${iPath}/${iName}.in -o ${orPath}/${line}.out -p ${pPath}/fls.prmtop -c ${cPath}/${line}_md${r}-${a}.rst -r ${orPath}/${line}_md${r}-${b}.rst -x ${orPath}/${line}_md${r}-${b}.mdcrd &" >> PBS_${jobname}
done<strList-fls

# sys2
iName=MD
r=2 #Sampling round
a=0 #input index
b=1 #output index
Path=/u/sciteam/shamsi/fls2/MD/flsflg

pPath=${Path}/MD${r}/top
cPath=${Path}/MD${r}/MD${r}-${a}
orPath=${Path}/MD${r}/MD${r}-${b}
path=${Path}/MD${r}/MD${r}-${b}
mkdir ${orPath}
while read line
do
  echo "aprun -n 1 -N 1 pmemd.cuda -O -i ${iPath}/${iName}.in -o ${orPath}/${line}.out -p ${pPath}/${line}.prmtop -c ${cPath}/${line}_md${r}-${a}.rst -r ${orPath}/${line}_md${r}-${b}.rst -x ${orPath}/${line}_md${r}-${b}.mdcrd &" >> PBS_${jobname}
done<strList-flsflg

# sys3
iName=MD
r=2 #Sampling round
a=0 #input index
b=1 #output index
Path=/u/sciteam/shamsi/fls2/MD/flsflgbak

pPath=${Path}/MD${r}
cPath=${Path}/MD${r}/MD${r}-${a}
orPath=${Path}/MD${r}/MD${r}-${b}
path=${Path}/MD${r}/MD${r}-${b}
mkdir ${orPath}
while read line
do
  echo "aprun -n 1 -N 1 pmemd.cuda -O -i ${iPath}/${iName}.in -o ${orPath}/${line}.out -p ${pPath}/flsflgbak.prmtop -c ${cPath}/${line}_md${r}-${a}.rst -r ${orPath}/${line}_md${r}-${b}.rst -x ${orPath}/${line}_md${r}-${b}.mdcrd &" >> PBS_${jobname}
done<strList-flsflgbak

echo "wait" >> PBS_${jobname}
