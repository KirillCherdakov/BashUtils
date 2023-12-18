#!/bin/bash
COUNTER=0
SUCCESS=0
FAILED=0
DIFF=""
# Colors_________
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyanide='\033[0;34m'
purple='\033[0;35m'
clear='\033[0m'
# Commands_______
sys_command=(
    "cat"
)
s21_command=(
    "./s21_cat"
)
flagArray=("-b" "-s" "-t" "-v" "-e" "-n")
multipleFlagsArray=("-bs" "-bt" "-bv" "-be" "-st" "-sv" "-sn" "-vn" "-bst" "-bse" "-bsv" 
"-nst" "-nse" "-nsv" "-vtsn" "-vtsb" "-vtns" "-vtne" "-vtnb" "-vtes" "-vten" "-vteb" "-vtbs" "-vtbn" "-vtbe" "-vstn" "-vsnb"
"-vsbt" "-vnts" "-vnte" "-bstv" "-bste" "-bstn" "-btve" "-btvn" "-btsv" "-bvst" "-bvte" "-bven" "-bvtn" "-sbtv" "-stve"
"-stvn" "-steb" "-stet" "-stnv" "-benstv") 
fileArray=("test_files/test_1_cat.txt" "test_files/test_2_cat.txt" "test_files/test_3_cat.txt"
 "test_files/test_4_cat.txt" "test_files/test_5_cat.txt" "test_files/test_6_cat.txt" 
 "test_files/test_case_cat.txt")
 multipleFilesArray=("test_files/test_1_cat.txt test_files/test_2_cat.txt" "test_files/test_1_cat.txt test_files/test_2_cat.txt test_files/test_3_cat.txt" 
 "test_files/test_3_cat.txt test_files/test_4_cat.txt" "test_files/test_5_cat.txt test_files/test_6_cat.txt"
 "test_files/test_1_cat.txt test_files/test_case_cat.txt" "test_files/test_6_cat.txt test_files/test_case_cat.txt"
 "test_files/test_2_cat.txt test_files/test_3_cat.txt" "test_files/test_3_cat.txt test_files/test_4_cat.txt"
 "test_files/test_4_cat.txt test_files/test_5_cat.txt" "test_files/test_5_cat.txt test_files/test_6_cat.txt"
 "test_files/test_case_cat.txt test_files/test_2_cat.txt" "test_files/test_case_cat.txt test_files/test_3_cat.txt"  
 "test_files/test_case_cat.txt test_files/test_4_cat.txt" "test_files/test_case_cat.txt test_files/test_5_cat.txt"
)


for files in "${fileArray[@]}"; do
        for flags in "${flagArray[@]}"; do
            let "COUNTER++"
            "${s21_command[@]}" $flags $files > "${s21_command[@]}".log
            "${sys_command[@]}" $flags $files > "${sys_command[@]}".log
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${CONTER} - ${green}SUCCESS${clear} $flags $files
                let "SUCCESS++"
                printf "\n"
            else
                echo "${s21_command[@]}" $flags $files >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $flags $files >> "${sys_command[@]}_errors".log
                echo -e ${red}FAILED${clear}
                let "FAILED++"
                printf "\n"
            fi
            rm -f cat.log
	        rm -f s21_cat.log
        done
done

for files in "${multipleFilesArray[@]}"; do
        for flags in "${multipleFlagsArray[@]}"; do
        let "COUNTER++"
            "${s21_command[@]}" $flags $files > "${s21_command[@]}".log
            "${sys_command[@]}" $flags $files > "${sys_command[@]}".log
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${CONTER} - ${green}SUCCESS${clear} $flags $files
                let "SUCCESS++"
                printf "\n"
            else

                echo -e ${red}FAILED${clear}
                let "FAILED++"
                printf "\n"
                echo "${s21_command[@]}" $flags $files >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $flags $files >> "${sys_command[@]}_errors".log
            fi
            rm -f cat.log
	        rm -f s21_cat.log
        done
done
echo ALL: ${COUNTER}
echo -e SUCCESSED:${green} ${SUCCESS} ${clear}
echo -e FAILED:${red} ${FAILED} ${clear}