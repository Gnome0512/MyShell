#!/bin/bash

#author:Gnome
#date:20160425
#function:draw snow and christmas tree
 
. ~/.bash_profile

#图形组成
trunk="|_________|"
root="_______________"
flower="*"
left_leaf="/"
middle_leaf="|"
right_leaf="\\"
star=( "\040/\040\040^\040\\" "\ \040\040\040\040\040/" "--\040\040\040\040-- " "\040\040\040/\\" )
leafs=
snows=

#当前终端总行数，列数等
line_num=`tput lines`
col_num=`tput cols`
half_col=` expr $col_num / 2 `
trunk_height=9
leaf_height=23
leaf_width=`expr $leaf_height \* 2 + 1 `
snow_length=0
allsnow=

#产生一个0-2的随机数，决定一层花的个数
num_random()
{
    return `expr $RANDOM % 3`
}

#生成花的列数随机数
col_random()
{
    tmp=`expr $1 \* 2 + 1`    
    return `expr $RANDOM % $tmp `
}

#生成花的颜色随机数
color_random()
{
    return `expr $RANDOM % 8`
}

#雪花间隔随机数
snow_random()
{
    return `expr $RANDOM % 10 + 5`
}


#清屏
tput sgr0
tput clear
echo

#输出
#雪花
for t in `seq $line_num`
do
    snows_length=0
    allsnow=
    for((i=0;i<25;i++))
    do
        snow_random
        snow_interval=$?
        for((j=0;j<$snow_interval;j++))
        do
            snows=$snows" "
        done
        snows=$snows"."
        snows_length=`expr $snows_length + 1 + $snow_interval`
        if [ `expr $snows_length + 16`  -gt $col_num ];then
            break
        fi
    done
        allsnow=$allsnow"${snows}\n"
        tput sc;tput cup 1 1;tput setf 7;echo -e "$allsnow";tput rc
done


#树根
tput sc;tput cup $line_num `expr $half_col - 7`;echo $root;tput rc
#sleep 1 

#树干
for((i=2;i<$trunk_height;i++))
do
    tput sc;tput cup `expr $line_num - $i` `expr $half_col - 5`;echo "$trunk";tput rc
#    sleep 1
done

#树叶
half_leaf=`expr $leaf_width / 2`
for((i=0;i<$leaf_height;i++))
do
    leafs=
    #添加左半部分树叶
    for((k=$half_leaf;k>0;k--))
    do
        leafs=${leafs}${left_leaf}
    done
    #添加中间部分树叶
    leafs=${leafs}${middle_leaf}
    #添加右半部分树叶
    for((k=$half_leaf;k>0;k--))
    do
        leafs=${leafs}${right_leaf}
    done
    #输出一层树叶    
    tput sc;tput cup `expr $line_num - $trunk_height - $i` `expr $half_col - $half_leaf`;tput setf 2;echo "$leafs";tput rc
    #添加花
    num_random
    num_r=$?
    color_random
    color_r=$?
    for((k=0;k<num_r;k++))
    do
        col_random $half_leaf
        col_r=$?
        tput sc
        tput cup `expr $line_num - $trunk_height - $i` `expr $half_col - $half_leaf + $col_r`;tput setf $color_r;
        tput bold
        tput blink
        echo "$flower"
	tput rc
    done
    half_leaf=`expr $half_leaf - 1`
done

#星星
tput sc

for((i=0;i<${#star[*]};i++))
do
    tput cup `expr $line_num - $trunk_height - $leaf_height - $i` `expr $half_col - 3`;tput setf 6;echo -e "${star[${i}]}" 
done

tput rc;
