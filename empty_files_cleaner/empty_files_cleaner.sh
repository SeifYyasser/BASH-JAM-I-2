#!/bin/bash

read -p "enter directory name :  " directory
directory_path=$(find ~ -type d -name "$directory")
printed=false

if [[ -z "$directory_path" ]]; then
    echo "Directory '$directory' does not exist!"
    exit 1
fi

for file in "$directory_path"/* ; do 
if [[ -f "$file" ]]  ;then
if [[ ! -s "$file" ]] ;then

if [[ "$printed" == false ]]; then
echo "the files will be deleted"
printed=true
fi
basename "$file" 
fi
fi 
done

if [[ "$printed" == true ]] ; then 
read -p "delete this files ? (y/n) " choice 
if [[ "$choice" == y ]] ;then
find "$directory_path" -type f -size 0 -delete
fi
fi
