#!/bin/bash
file1="$1"
file2="$2"
file3="$3"
echo "
User Name: kimsumin
Student Number: 12181171
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer' 9. Exit
--------------------------
"

choice=0
while true; do 
 read -p "Please enter choice [ 1-9 ]: " choice
case $choice in
        1)
            read -p "please enter 'movie id' (1~1682): " movie_id
            cat $file1 | awk  'NR=='"$movie_id"''  
            ;;
        2)
            read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(Y/n) " y_or_no
		
	  	if [ "$y_or_no" == "y" ]; then
	    	
		cat $file1 | awk -F \| '$7==1 {print $1,$2} ' | awk 'NR <= 10 {print}' 
		fi
 
            ;;
        3)
	     
             read -p "please enter 'movie id' (1~1682): " movie_id
             average=$(cat $file2 | awk '$2=='"$movie_id"''| awk '{sum+=$3} END {print sum/NR}  ')
             echo "average rating of '"$movie_id"' : '"$average"'"
		 ;;
        4)
            read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n)" y_or_no

                if [ "$y_or_no" == "y" ]; then

                cat $file1 | awk 'NR <= 10 {print}' |  awk -F'|' -v OFS='|' '{$5=""} 1'
                fi

            ;;
        5)
             read -p "Do you want to get the data about users from 'u.user’?(y/n)" y_or_no

                if [ "$y_or_no" == "y" ]; then

                cat $file3 | awk 'NR <= 10 {print}' | awk -F'|' '{gender = ($3 == "M") ? "male" : "female"; printf "user %d is %d years old %s %s\n", $1, $2, gender, $4}'
                fi

            ;;
        6)
            read -p "Do you want to Modify the format of ;release date' in 'u.item’?(y/n)" y_or_no

                if [ "$y_or_no" == "y" ]; then

                cat $file1 | awk -F '|' '$1>=1673 && 1<=1682 {print}'| awk -F'|' -v OFS='|' '{
   		 split($3, date, "-")
   		 month["Jan"] = "01"; month["Feb"] = "02"; month["Mar"] = "03";
  		 month["Apr"] = "04"; month["May"] = "05"; month["Jun"] = "06";
   		 month["Jul"] = "07"; month["Aug"] = "08"; month["Sep"] = "09";
    		 month["Oct"] = "10"; month["Nov"] = "11"; month["Dec"] = "12";
   		 if (date[2] in month) $3 = date[3] month[date[2]] date[1]} 1' 
                fi
            ;;
        7)
              read -p "please enter 'user id' (1~943): " user_id
            cat $file2 | awk  '$1=='"$user_id"' {print}'| awk '{print $2}' | sort -n | paste -sd'|' - | sed 's/|$/\n/' 
		sorted_data=$( cat $file2 | awk  '$1=='"$user_id"' {print}'| awk '{print $2}' | sort -n | paste -sd'|' - | sed 's/|$/\n/')
           cat $file1 | awk -F'|' -v sorted="$sorted_data" 'BEGIN {split(sorted, array, "|")} {for (i in array) if ($1 == array[i]) {print $1 "|" $2; count++; if(count==10)exit}}' 
            ;;
        8)
           
                read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)" y_or_no

                if [ "$y_or_no" == "y" ]; then

                data=$(cat $file3 | awk -F'|' '($2 >= 20 && $2 <= 29) && $4 == "programmer" {print $1}')
		data1=$(echo "$data" | tr '\n' ' ')
		
		cat $file2 | awk -v ids="$data1" 'BEGIN { split(ids, arr, " "); }
{
    for (i in arr) {
        if(arr[i] == $1) {
            print $2, $3;
            next;  
        }
    }
}' | awk '{
    sum[$1] += $2;  
    count[$1]++;    
}

END {
    for (key in sum) {
        average = sum[key] / count[key];
        avgRounded = sprintf("%.5f", average + 0.5e-5); 
        
        if (avg == int(average)) {
            printf "%s %d\n", key, average;
        } else {
            sub(/\.?0+$/, "", avgRounded); 
            printf "%s %s\n", key, avgRounded;
        }
    
    }
}' | sort -n
                fi

         
            ;;
        9)
            echo "Bye"
            exit 0
            ;;
        *)
            ;;
    esac


done 
 
