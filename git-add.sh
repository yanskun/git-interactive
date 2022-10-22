#!/bin/bash

status=`git status --porcelain | sed s/^...// | cut -d' ' -f1`
files=(`echo $status`)

CurrentChoice=0

TextUnderLine(){ printf "\033[4m" ; }
TextBold(){ printf "\033[1m" ; }
ResetStyle(){ printf "\033[0m"; }

function print_menu() {
  for i in "${!files[@]}"; do
    if [[ "$i" = "$CurrentChoice" ]]; then
      TextBold
      printf " > "
      TextUnderLine
      echo "${files[$i]}"
    else
      echo "   ${files[$i]}"
    fi
    ResetStyle
  done
}

function run_menu() {
  clear
  print_menu

  while read -rsn1 input
  do
    case "$input" in
      $'\x1b') # ESC
        break
        ;;
      $'k') # Up
        if (( "$CurrentChoice" != 0 )); then
          CurrentChoice=$((CurrentChoice - 1))
          clear
          print_menu
        fi
        ;;
      $'j') # Down
        if (( "$CurrentChoice" != "${#files[@]}" - 1 )); then
          CurrentChoice=$((CurrentChoice + 1))
          clear
          print_menu
        fi
        ;;
      $'') # Enter
        echo ""
        echo "   git add ${files[$CurrentChoice]}"
        git add "${files[$CurrentChoice]}"
        break
        ;;
      esac
  done
}

run_menu
