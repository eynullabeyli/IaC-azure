#!/bin/bash

# Script to create blank git commits every 3 days from 2025-01-01 to 2025-05-31

git checkout development

date_start="2025-01-01"
date_end="2025-05-31"
current_date="$date_start"

while [[ "$current_date" < "$date_end" || "$current_date" == "$date_end" ]]; do
  GIT_AUTHOR_DATE="$current_date 12:00:00" \
  GIT_COMMITTER_DATE="$current_date 12:00:00" \
  git commit --allow-empty -m "New adventure for $current_date"
  current_date=$(date -j -v+3d -f "%Y-%m-%d" "$current_date" +"%Y-%m-%d")
done

echo "Done creating blank commits every 3 days from $date_start to $date_end." 