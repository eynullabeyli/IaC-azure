#!/bin/bash

# Script to create commits every 3 days from 2025-01-01 to 2025-05-31, updating example.txt

git checkout development

date_start="2025-01-01"
date_end="2025-05-31"
current_date="$date_start"

while [[ "$current_date" < "$date_end" || "$current_date" == "$date_end" ]]; do
  echo "New adventure for $current_date" >> example.txt
  GIT_AUTHOR_DATE="$current_date 12:00:00" \
  GIT_COMMITTER_DATE="$current_date 12:00:00" \
  git add example.txt
  git commit -m "New adventure for $current_date"
  current_date=$(date -j -v+3d -f "%Y-%m-%d" "$current_date" +"%Y-%m-%d")
done

echo "Done creating commits every 3 days from $date_start to $date_end on development branch, updating example.txt." 