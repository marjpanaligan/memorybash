root@marj:~ # cat memory_check2.sh
#!/bin/bash
while getopts "c:w:e:" flag; do
    case "$flag" in
          c)critical=$OPTARG;;
          w)warning=$OPTARG;;
          e)email=$OPTARG;;
          *)echo "Invalid argument";;
    esac
done

declare -i TOTAL_MEMORY=$( free | grep Mem: |awk '{print $2}')
declare -i USED_MEMORY=$( free | grep Mem: | awk '{print $3}')
mem_used=($USED_MEMORY/$TOTAL_MEMORY)

echo "Total memory is: " $TOTAL_MEMORY
echo "Used memory is " $USED_MEMORY
#awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); percentage = rounded*100; print percentage}'



#awk  'BEGIN{ rounded = sprintf("%.2f", '$mem_used'); um = rounded*100; print "Percentage: " um"%"}BEGIN{if (um -ge '$critical') print "2"; else if(um -ge '$warning' && -le '$critical') print "1"; else if(um -lt '$warning') print "0";}'

mem=$(echo "scale=2; ${mem_used}*100"| bc)
memu=${mem%.*}
echo "Percentage: " $memu"%"
echo "Crtical threshold: " $critical
echo "Warning threshold: " $warning
echo "Email address: " $email

if [ ${memu} -ge "$critical" ];
then
   #echo "exit value is 2";
   #echo -e "enter email address";
    #read e;
    emailAddress=$email
       current=$(date '+%Y-%m-%d %H:%M:%S')
       printf "\nEmail sent. Content is the top 10 processes that consume most of the memory load.\n\n" ;
       ps aux --sort -rss | head -n 11| mail -s '${current} memory check - critical' "$emailAddress";
    #ps aux --sort -rss | head -n 11
      echo "exit value is 2";
      exit 2;
elif [[ ${memu} -ge "$warning" ]] && [[ ${memu} -lt "$critical" ]] ;
then
      echo "exit value is 1"
      exit 1;
elif [[ ${memu} -lt "$warning" ]] || [[${memu} == 0 ]] ; then
      echo "exit value is 0";
      exit 0;
else
      echo "Invalid";

fi
shift $(($OPTIND -1))
