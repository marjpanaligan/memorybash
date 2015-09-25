# memorybash
note: not yet done... ongoing
root@marj:~ # vi memory_check.sh
#!/bin/bash


echo -e "enter critical threshold"
read c
echo -e "enter warning threshold"
read w

declare -i c
declare -i w

function percent {
declare -i TOTAL_MEMORY=$( free | grep Mem: |awk '{print $2}')
declare -i USED_MEMORY=$( free | grep Mem: | awk '{print $3}')
mem_used=($USED_MEMORY/$TOTAL_MEMORY)

echo "Total memory is: " $TOTAL_MEMORY
echo "Used memory is " $USED_MEMORY
awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); percentage = rounded*100; print "Percentage: " percentage"%"}'
}
percent


#awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); percentage = rounded*100; print "Percentage: " percentage"%"}{if ( percentage >= '$c' ) print "2"; else if ( percentage >= '$w' < '$c' ) print "1"; else if ( percentage < '$w' ) print "0";}'
#echo "scale=2; ${mem_used}"| bc

if [ percent >= $c ] ; then
  echo "2"
else
  if [ percent >= $w < $c ] ; then
    echo "1"
 else
   if [ percent < $w ] ; then
     echo "0"
    fi
  fi
fi
