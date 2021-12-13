#! /bin/bash
#Shortest Job First (SJF) Scheduling Algorithm
function shortestjobfirst {
#Initializing Bash variables
awt=0 
totalwt=0
totaltat=0
atat=0
temp=0
declare -a  wt
declare -a  tat
#sorting burst time in ascending order using selection sort
for ((i = 0; i<${number-1}; i++))
do
    
    for((j = 0; j<${number-i-1}; j++))
    do
    
        if [[ "${Btime[$j]}" -gt "${Btime[$j+1]}" ]];
        then
            # swaping Burst time array
            temp=${Btime[$j]};
            Btime[$j]=${Btime[$j+1]};
            Btime[$j+1]=$temp;

            #swaping process positon
            temp=${p[$j]};
            p[$j]=${p[$j+1]};
            p[$j+1]=$temp;
        fi
    done
done
    echo -e "Process\t    Burst Time    \tWaiting Time\tTurnaround Time" 
    for ((i=1;i<=number;i++))
    do
        wt[i]=0;
        tat[i]=0;
        for ((j=0;j<i;j++))
        do
            wt[i]="$((wt[i]+Btime[j]))"     #calculate waiting time  
        done
        
        totalwt="$((totalwt+wt[i]))"     #calculate total waiting time
        tat[i]="$((Btime[i]+wt[i]))"     #calculate turnaround time
        totaltat="$((totaltat+tat[i]))"     #calculate total turnaround time
        echo -e "${p[i]}\t\t  ${Btime[i]}\t\t    ${wt[i]}\t\t\t${tat[i]}"
    done

 awt=$(echo 'scale=2;' "$totalwt" / "$number" | bc -l)     #calculate average waiting time
 atat=$(echo 'scale=2;' "$totaltat" / "$number" | bc -l)   #calculate average turnaround time
echo -e "\n"
echo "Total waiting time =" "$totalwt"
echo "Average waiting time =" "$awt"
echo "Total Turnaround Time =" "$totaltat"
echo "Average Turnaround Time =" "$atat"
}

#Round Robin (RR) Scheduling Algorithm
function roundrobin {
  #Initializing Bash variables
   timeQuantum=0
   awt=0
   atat=0
   temp=0
   temp2=0
   GanttChart=0
   totalwt=0
   totaltat=0
   
   declare -a  wt
   declare -a  tat
echo "Enter the Quantum time -- "; #Accepts user input for Quantum Time and Input Validation
read -r timeQuantum

while [[ -z "$timeQuantum" ]] || [[ "$timeQuantum" -le 0 ]]
do
echo "Quantum time cannot be blank or less than 1, please try again."
echo "Enter the Quantum time --  "
read -r timeQuantum
done 

echo -e "\n\t\t\t\tGantt Chart"
echo -n "0"
  while ((1))
  do
    for ((i = 1,count=0; i <=number; i++))
    do
      temp=$timeQuantum
      
      if [ "${rem_bt[i]}" -eq 0 ] 
      then 
        ((count++))
        
        continue
      fi

      if [ "${rem_bt[i]}" -gt "$timeQuantum" ]
        then
        rem_bt[$i]=$((rem_bt[i]-timeQuantum))
        GanttChart=$((GanttChart+timeQuantum))
        echo -n " -> P[""$i""] <-" "$GanttChart"
        else 
          if [ "${rem_bt[i]}" -ge 0 ]
          then
            temp=${rem_bt[i]};
            GanttChart=$((GanttChart+rem_bt[i]))
            echo -n " -> P[""$i""] <-" "$GanttChart"
            rem_bt[$i]=0;
          fi        
      fi
      temp2=$((temp2+temp))
      tat[$i]=$temp2
    done
    if [ "$number" -eq "$count" ]
    then
    break
    fi

  done
    echo -e "\n\nProcess\t    Burst Time    \tWaiting Time\tTurnaround Time"
    for ((i = 1; i <= number; i++))
    { 
        wt[i]=$((tat[i]-Btime[i]))
        totalwt=$((totalwt+wt[i]))
        totaltat=$((totaltat+tat[i]))
        
       echo -e "$i\t\t  ${Btime[i]}\t\t    ${wt[i]}\t\t\t${tat[i]}"
    }
    awt=$(echo 'scale=2;' "$totalwt" / "$number" | bc -l)
    atat=$(echo 'scale=2;' "$totaltat" / "$number" | bc -l)

echo "Total waiting time =" "$totalwt"
echo "Average waiting time =" "$awt"
echo "Total Turnaround Time =" "$totaltat"
echo "Average Turnaround Time =" "$atat"
}

x=yes
while [ "$x" != "n" ]
do
#Accepts user input for Number of Processes and Input Validation
echo "Enter the number of processes -- "
read -r number
while [[ "$number" -le 1 ]] || [[ -z "$number" ]]
do
echo "Error: Input valid number of processes or Input cannot be blank"
echo "Please try again."
echo "Enter the number of processes -- "
read -r number
done

declare -a Btime
declare -a  p
declare -a  rem_bt

#Accepts user input for Burst Time and Input Validation
for (( i=1; i<=number; i++ ))
do

echo "Enter Burst Time for Process -- $i"
read -r "Btime[i]"

while [[ "${Btime[i]}" -lt 1 ]] || [[ -z "${Btime[i]}" ]]
do
echo "Error: Input valid burst time for the process or Inputs cannot be blank"
echo "Please try again."
echo "Enter Burst Time for Process -- $i"
read -r "Btime[i]"
done
p[i]=$i  #contains process number
rem_bt[i]=${Btime[i]} #remaining process
done

echo -e "CPU burst Time for processes in nano second --" "${Btime[@]}"
echo -e "Process Number for CPU burst time           --" "${p[@]}"
echo ""
echo "Enter your choice, or 0 for exit: "
echo "Press 1 for Shortest Job First"
echo "Press 2 for Round Robin"
read -r choice 
echo "You choose option: $choice"

##Switch Case
case $choice in
1) echo -e "\t\tShortest Job First Scheduling\n"
shortestjobfirst
;; 
2) echo -e "\t\tRound Robin Scheduling\n"
roundrobin
;;
0)
echo "OK, see you!"
exit 0
;; 
*)
echo "Your entry does not match any of the conditions! try a number from 0 to 2."
;;
esac
echo ""
echo -n "Do you want to calculate again? (Y/n): "
read -r x
clear && clear
echo "You typed: $x"
echo "" 
done
