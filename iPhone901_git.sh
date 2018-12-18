#!/bin/bash
#Copyright(c)    2018 Netease
#All rights reserved.
#Program:
# This program push code automatically.
#Author:    lilin
#Version:    0.1
#History:
#2018/12/12    Netease study


export commitMessage=''
export buildXcodeChoice=''

get_Input_Message() {
    read -p "请输入你的commit信息:（默认用户+h提交时间） " commitMessage
    read -p "请输入你是否要编译工程(y/n)（默认n）: " buildXcodeChoice
    
    if [ -z "$commitMessage"]; then
        commitMsg="$USER commit at `date +%Y年%m月%d日%H:%M:%S`"
    fi
    echo "这是你的提交信息: ${conflictMsg}"
    echo "这是你的编译选择: ${buildXcodeChoice}"
}

git_merge(){
	git fetch origin
	current_date_time="`date +%Y%m%d%H%M%S`"
    echo "这是你的stash: ${current_date_time}"
	git stash save $current_date_time
	git pull
	git stash apply

    conflictMsg=$(git diff --name-only --diff-filter=U)
    echo "This is conflict messages: ${conflictMsg}"
}

git_push(){
#    [alias] chs = git add --all && git commit -m $commitMsg && git push
    git add --all
    git commit -m "$commitMsg"
    git push
}

run_xcworkspace(){
    cd LLModularizationDemo
    xcodebuild -workspace LLModularizationDemo.xcworkspace -scheme LLModularizationDemo

    if [ $? -eq 0 ]; then
        echo "Build Success"
    else
        echo "Build Failed"
    fi
}

main() {
    get_Input_Message
    git_merge
    if [ "$buildXcodeChoice" = "y" ]; then
        run_xcworkspace
    fi
    git_push
}

main

