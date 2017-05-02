#!/bin/bash

echo -n "Title: "
read title
if [ ! "$title" ]; then
  exit 2
fi

name=${title,,}
name=${name// /-}
name=${name//[^[:alnum:]-]/}

file="$(date +'%Y-%m-%d')-$name.md"
date=$(date +"%Y-%m-%d %H:%M:%S %z")

echo "---" > "$file"
echo "layout: post" >> "$file"
echo "title: $title" >> "$file"
echo "date: $date" >> "$file"
echo "categories: draft" >> "$file"
echo "tags: " >> "$file"
echo "---" >> "$file"
