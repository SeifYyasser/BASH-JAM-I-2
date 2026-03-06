#!/bin/bash
function add(){
    result=$((num1 + num2))
    echo "Result = $result "
} 
function multiple(){
 result=$((num1 * num2))
echo "Result = $result "
}
function division(){
 result=$( echo " scale=2; $num1 / $num2" | bc -l)
echo "Result = $result "
}
function minus(){
 result=$((num1 - num2))
echo "Result = $result "
}
echo "enter first number"
read num1
echo "enter second number"
read num2
echo "the operation (+,/,*,-)"
read op
if [ "$op" = "+" ]
then
add
elif [ "$op" = "-" ]
then 
minus 
elif [ "$op" = "*" ]
then
multiple
elif [ "$op" = "/" ]
then
division
else 
echo "invalid operation"
fi
