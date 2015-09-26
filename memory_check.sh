root@marj:~ # vi memory_check.sh
#!/bin/bash


echo -e "enter critical threshold"
read c
echo -e "enter warning threshold"
read w

declare -i critical=c
declare -i warning=w

declare -i TOTAL_MEMORY=$( free | grep Mem: |awk '{print $2}')
declare -i USED_MEMORY=$( free | grep Mem: | awk '{print $3}')
mem_used=($USED_MEMORY/$TOTAL_MEMORY)

echo "Total memory is: " $TOTAL_MEMORY
echo "Used memory is " $USED_MEMORY
#awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); percentage = rounded*100; print percentage}'
#awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); um = rounded*100; print "Percentage: " um"%"}BEGIN{if (um -ge '$critical') print "2"; else if(um -ge '$warning' && -le '$critical') print "1"; else if(um -lt '$warning') print "0";}'

mem=$(echo "scale=2; ${mem_used}*100"| bc)
memu=${mem%.*}
echo "Percentage is: " $memu"%"
echo "Crtical threshold: " $critical
echo "Warning threshold: " $warning


if [ ${memu} -ge "$critical" ];
then
 echo "Value is 2";
elif [[ ${memu} -ge "$warning" ]] && [[ "$memu" -lt "$critical" ]] ;
then
    echo "Value is 1";
 elif [ ${memu} -lt "$warning" ]; then
     echo "Value is 0";

fi
