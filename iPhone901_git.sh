#!/bin/bash
#Copyright(c)    2018 Netease
#All rights reserved.
#Program:
# This program push code automatically.
#Author:    lilin
#Version:    0.1
#History:
#2018/12/12    Netease study

export directory=''
export commitMessage=''
export buildXcodeChoice=''
export selectedScheme=''

function get_Input_Message() {
    read -p "请输入你的commit信息:（默认用户+提交时间） " commitMessage
    read -p "请输入你是否要编译工程(y/n)（默认n）: " buildXcodeChoice
    read -p "请输入你选择的scheme: " selectedScheme
    xcodebuildList=$(xcodebuild -list)
    echo "zhelishi${xcodebuildList}"
    array=(${xcodebuildList//Schemes:/})
    if [ -z "$array"]; then
        for i in $(echo $array | tr "\n")
        do
            echo "hahahaha:${i}"
        done
    fi

    if [ -z "$commitMessage"]; then
        commitMsg="$USER commit at `date +%Y年%m月%d日%H:%M:%S`"
    fi
    echo "这是你的提交信息: ${commitMessage}"
    echo "这是你的编译选择: ${buildXcodeChoice}"
    echo "这是你的编译scheme: ${selectedScheme}"
}

function git_merge() {
	git fetch origin
	current_date_time="`date +%Y%m%d%H%M%S`"
    echo "这是你的stash: ${current_date_time}"
	git stash save $current_date_time
	git pull
	git stash apply

    conflictMsg=$(git diff --name-only --diff-filter=U)
    echo "This is conflict messages: ${conflictMsg}"
}

function git_push() {
#    [alias] chs = git add --all && git commit -m $commitMsg && git push
    git add --all
    git commit -m "$commitMsg"
    git push
}

function get_xcworkspace_directory() {
    xcworkspaceCount="$(find ./ -name "*.xcworkspace" | grep -v '.xcodeproj' | wc -l)"
    echo "xcworkspaceCount:${xcworkspaceCount}"
    if [[ "$xcworkspaceCount" -eq 1 ]] ; then
        directory=$(find ./ -name "*.xcworkspace" | grep -v '.xcodeproj')
        return 0
    else
        if [[ "$xcworkspaceCount" -gt 1 ]]; then
            echo "找到超过1个xcworkspace"
            return 1
        else
            echo "没有xcworkspace可执行"
            return 1
        fi
    fi
}

function run_xcworkspace(){
    xcodebuild -workspace ${vdirectoryar##*/} -scheme ${selectedScheme}

    if [ $? -eq 0 ]; then
        echo "Build Success"
    else
        echo "Build Failed"
    fi
}

main() {
    get_xcworkspace_directory
    if [ $? -eq 0 ]; then
        cd ${directory%/*}
        get_Input_Message
        git_merge
        if [ "$buildXcodeChoice" = "y" ]; then
            run_xcworkspace
        fi
        git_push
    else
        echo "执行失败"
    fi
}

main

