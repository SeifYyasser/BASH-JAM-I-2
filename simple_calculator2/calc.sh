#! /bin/bash

read first operation second

case $operation in 

+)  echo "$(($first + $second))"
;;

-) echo "$(($first - $second))"
;;

/) echo "$(($first / $second))"
;;

*) echo "$(($first * $second))"
;;

esac


