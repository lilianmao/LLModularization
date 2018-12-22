#!/bin/bash
#Copyright(c)    2018 Netease
#All rights reserved.
#Program:
# This program push code automatically.
#Author:    lilin
#Version:    0.1
#History:
#2018/12/12    Netease study


#脚本功能：帮助你拉取新代码，apply stash，build工程，推送代码
#
#使用方法：
#1. 添加脚本执行权限：chmod +x iPhone901_git.sh
#2. 运行脚本：./iPhone901_git.sh
#3. 需要输入你提交的commit信息，你是否要build工程，如果需要build工程，需要选择scheme，如果不需要build，则不需要选择scheme

export directory=''
export commitMessage=''
export buildXcodeChoice=''
export selectedScheme=''

commit_dev="@dev"
commit_bugfix="@bugfix"
commit_misc="@misc"

commit_libs=(${commit_dev}
             ${commit_bugfix}
             ${commit_misc})

function get_Input_Message() {
    # 处理commit信息
    read -p "请输入你的commit信息（默认用户+提交时间）：" commitMessage

    flag=0
    for index in "${!commit_libs[@]}"
    do
        temp=${commit_libs[index]}
        if [[ "${commitMessage}" =~ ^"$temp" ]]; then
            flag=1
        fi
    done

    if [[ "$flag" -ne 1 ]] ; then
        echo "以下可供选择commit信息的类型："
        for index in "${!commit_libs[@]}"
        do
            echo "$index ${commit_libs[index]}"
        done
        read -p "请输入你选择commit类型: " choice
        commitMessage="${commit_libs[choice]} $commitMessage"
    fi
    echo "你的commit信息：${commitMessage}"

    # 处理build选择
    read -p "请输入你是否要编译工程(y/n)（默认n）: " buildXcodeChoice
    if [ "$buildXcodeChoice" = "y" ]; then
        get_xcodebuild_list
    fi
}

function get_xcodebuild_list() {
    xcodebuildList=`xcodebuild -list`
    array=(${xcodebuildList//:/ })

    echo "以下是你的schemes："
    i=0
    schemes=()          # schemes数组
    for index in "${!array[@]}"
    do
        if [[ "$i" -eq 1 ]] ; then
            schemes+=(${array[index]})
            echo "$((i-1)) ${array[index]}"
        fi
        if [ "${array[index]}" = "Schemes" ]; then
            ((i++));
        fi
    done

    read -p "请输入你选择的scheme: " choice
    echo "你选择的Scheme是：${schemes[choice]}"
    selectedScheme=${schemes[choice]}
}

function git_merge() {
	git fetch origin
	current_date_time="`date +%Y%m%d%H%M%S`"
    echo "这是你的stash: ${current_date_time}"
	git stash save $current_date_time
	git pull
	git stash apply

    conflictMsg=$(git diff --name-only --diff-filter=U)
    if [ ! -n $conflictMsg ]; then
        return 0
    else
        echo "This is conflict messages: ${conflictMsg}"
        return 1
    fi
}

function git_push() {
    git add --all
    git commit -m "$commitMessage"
    git push
}

function get_xcworkspace_directory() {
    xcworkspaceCount="$(find ./ -name "*.xcworkspace" | grep -v '.xcodeproj' | wc -l)"
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
    xcodebuild -workspace ${directory##*/} -scheme ${selectedScheme}

    if [ $? -eq 0 ]; then
        echo "Build Success"
    else
        echo "Build Failed"
    fi
    return $?
}

main() {
    cd ..
    get_xcworkspace_directory
    if [ $? -eq 0 ]; then
        cd ${directory%/*}
        get_Input_Message
        git_merge
        if [ $? -eq 0 ]; then
            if [ "$buildXcodeChoice" = "y" ]; then
                run_xcworkspace
                if [ $? -eq 0 ]; then
                    git_push
                fi
            else
                git_push
            fi
        else
            echo "有冲突，执行失败"
        fi
    else
        echo "执行失败"
    fi
}

main

