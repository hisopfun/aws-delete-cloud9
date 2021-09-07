#!/bin/bash
list=(`aws cloud9 list-environments | jq -r '.[] | .[]'`)

echo ${list[*]}
echo ${#list[*]}

for i in ${list[@]};
do
	echo $i
  statuss=$(aws cloud9 describe-environment-status --environment-id $i | jq -r .status) 
  describe=$(aws cloud9 describe-environments --environment-id $i)
  echo $describe | jq .
  arn=$(echo $describe | jq .environments | jq -r .[].ownerArn)
  echo $arn

  if [ "$statuss" = "stopped" ]
  then
    echo "already stopped"
    echo $statuss
  elif [ "$statuss" = "stopping" ]
  then
    echo "stopping"
    echo $statuss
  else
    echo "not stop"
    echo $statuss
    if [ -z "$1" ]
    then 
      echo "1 is empty"
    else
      if [[ "$arn" = *"$1"* ]]
      then
        echo "is $1 "$arn" deleting"
        aws cloud9 delete-environment --environment-id $i
      fi
    fi
  fi
done


