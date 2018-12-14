#!/bin/bash
#Copyright(c)    2018 Netease
#All rights reserved.
#Program:
# This program push code automatically.
#Author:    lilin
#Version:    0.1
#History:
#2018/12/12    Netease study


export commitMsg=''

get_Input_Message() {
    read -p "Please input commit message: " commitMsg
    
    if test -z "$username"; then
    commitMsg="$USER commit at `date +%Y年%m月%d日%H:%M:%S`"
    fi
    echo $commitMsg
    
    export commitMsg
}

git_merge(){
	git fetch origin
	current_date_time="`date +%Y%m%d%H%M%S`"
    echo $current_date_time
	git stash save $current_date_time
	git pull
	git merge master

    conflictMsg=$(git diff --name-only --diff-filter=U)
    echo "This is conflict messages: ${conflictMsg}"
}

git_push(){
#    [alias] chs = git add --all && git commit -m $commitMsg && git push
    git add --all
    git commit -m "$commitMsg"
    git push
}

main() {
    get_Input_Message
	git_merge
#    git_push
}

main

