#!/bin/bash
cd ~/dotfiles
git add .
git diff --cached --quiet || git commit -m "auto: sync $(date '+%Y-%m-%d %H:%M')"
git push
