#!/bin/bash
COUNTER=0;
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
    "grep"
)
s21_command=(
    "./s21_grep"
)
flagArray=(
     "-c" "-l" "-n" "-h" "-i" "-s" "-o" "-v"
    )
pairFlagArray=(
    "-vc" "-vl" "-vn" "-vi" "-vi" "-vs" "-vo"
    "-vcl" "-vcn" "-vch" "-vci" "-vco" "-vln" "-vlh"
    "-vnh" "-vni" "-vns" "-vno" "-vhi" "-vhs" "-vho"
    "-vcln" "-vclh" "-vcli" "-vcls" "-vclo" "-vcnh"
    "-vclnhiso"
    ) 
fileArray=(
    "test_files/test_0_grep.txt" "test_files/test_1_grep.txt" "test_files/test_2_grep.txt" 
    "test_files/test_3_grep.txt" "test_files/test_4_grep.txt" "test_files/test_5_grep.txt"
    "test_files/test_6_grep.txt" "test_files/test_7_grep.txt" "test_files/test_ptrn_grep.txt"
    )
multipleFilesArray=(
    "test_files/test_0_grep.txt test_files/test_1_grep.txt test_files/test_2_grep.txt"
    "test_files/test_1_grep.txt test_files/test_2_grep.txt test_files/test_3_grep.txt"
    "test_files/test_3_grep.txt test_files/test_4_grep.txt test_files/test_5_grep.txt"
    "test_files/test_5_grep.txt test_files/test_6_grep.txt test_files/test_7_grep.txt" 
    "test_files/test_6_grep.txt test_files/test_7_grep.txt test_files/test_ptrn_grep.txt"
    "test_files/test_0_grep.txt test_files/test_1_grep.txt test_files/test_ptrn_grep.txt"
    "test_files/test_1_grep.txt test_files/test_2_grep.txt test_files/test_ptrn_grep.txt"
    "test_files/test_4_grep.txt test_files/test_3_grep.txt test_files/test_ptrn_grep.txt"
    "test_files/test_5_grep.txt test_files/test_6_grep.txt test_files/test_ptrn_grep.txt"

)
patternArray=(
    "FLAGS" "for" "^int" "^print" "intel" "int" "regex" "while" "void" "'.'"
)

manual=(
"-n for test_files/test_1_grep.txt test_files/test_2_grep.txt"
"-n for test_files/test_1_grep.txt"
"-c -e '\\' test_files/test_1_grep.txt"
"-e ^int test_files/test_1_grep.txt"
"-e"
"-c -l aboba test_files/test_1_grep.txt test_files/test_5_grep.txt"
"-e ank -v test_files/test_1_grep.txt"
"-l for test_files/test_1_grep.txt test_files/test_2_grep.txt"
"-e = -e out test_files/test_5_grep.txt"
"-e ing -e as -e the -e not -e is test_files/test_6_grep.txt"
"-l for no_file.txt test_files/test_2_grep.txt"
"-e int -si no_file.txt main.c no_file2.txt main.h"
)

printf "******************************************************\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "*           TESTING WITH 1 FLAG AND 1 FILE           *\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "******************************************************\n"
rm -f "${s21_command[@]}_errors".log
rm -f "${sys_command[@]}_errors".log
for files in "${fileArray[@]}"; do
    for flags in "${flagArray[@]}"; do
        for patterns in "${patternArray[@]}"; do
            "${s21_command[@]}" $flags $patterns $files > "${s21_command[@]}".log
            "${sys_command[@]}" $flags $patterns $files > "${sys_command[@]}".log
            let "COUNTER++"
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${COUNTER} - ${green}Success${clear} $flags $files
                let "SUCCESS++"
                printf "\n"
            else
                echo -e ${COUNTER} - ${red}Failed${clear} $flags $patterns $files
                printf "\n"
                "$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
                echo "${s21_command[@]}" $flags $patterns $files >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $flags $patterns $files >> "${sys_command[@]}_errors".log
                let "FAILED++"
                printf "\n"
            fi
                rm -f "${sys_command[@]}".log
                rm -f "${s21_command[@]}".log
        done
    done
done

printf "******************************************************\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "*          TESTING WITH 2 FLAGS AND 1 FILE           *\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "******************************************************\n"
for files in "${fileArray[@]}"; do
    for pairFlags in "${pairFlagArray[@]}"; do
        for patterns in "${patternArray[@]}"; do
            "${s21_command[@]}" $pairFlags $patterns $files > "${s21_command[@]}".log
            "${sys_command[@]}" $pairFlags $patterns $files > "${sys_command[@]}".log
            let "COUNTER++"
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${COUNTER} - ${green}Success${clear} $pairFlags $files
                let "SUCCESS++"
                printf "\n"
            else
                echo -e ${COUNTER} - ${red}Failed${clear} $pairFlags $patterns $files
                printf "\n"
                "$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
                echo "${s21_command[@]}" $pairFlags $patterns $files >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $pairFlags $patterns $files >> "${sys_command[@]}_errors".log
                let "FAILED++"
                printf "\n"
            fi
                rm -f "${sys_command[@]}".log
                rm -f "${s21_command[@]}".log
        done
    done
done
printf "******************************************************\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "*         TESTING WITH 1 FLAG AND 1+ FILES           *\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "******************************************************\n"

for multipleFiles in "${multipleFilesArray[@]}"; do
    for flags in "${flagArray[@]}"; do
        for patterns in "${patternArray[@]}"; do
            "${s21_command[@]}" $flags $patterns $multipleFiles > "${s21_command[@]}".log
            "${sys_command[@]}" $flags $patterns $multipleFiles > "${sys_command[@]}".log
            let "COUNTER++"
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${COUNTER} - ${green}Success${clear} $flags $multipleFiles
                let "SUCCESS++"
                printf "\n"
            else
                echo -e ${COUNTER} - ${red}Failed${clear} $flags $patterns $multipleFiles
                printf "\n"
                "$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
                echo "${s21_command[@]}" $flags $patterns $multipleFiles >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $flags $patterns $multipleFiles >> "${sys_command[@]}_errors".log
                let "FAILED++"
                printf "\n"
            fi
                rm -f "${sys_command[@]}".log
                rm -f "${s21_command[@]}".log
        done
    done
done

printf "******************************************************\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "*        TESTING WITH 1+ FLAG AND 1+ FILES           *\n"
printf "*                                                    *\n"
printf "*                                                    *\n"
printf "******************************************************\n"
for multipleFiles in "${multipleFilesArray[@]}"; do
    for pairFlags in "${pairFlagArray[@]}"; do
        for patterns in "${patternArray[@]}"; do
            "${s21_command[@]}" $flags $patterns $multipleFiles > "${s21_command[@]}".log
            "${sys_command[@]}" $flags $patterns $multipleFiles > "${sys_command[@]}".log
            let "COUNTER++"
            DIFF="$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
            if [ "$DIFF" == "Files "${s21_command[@]}".log and "${sys_command[@]}".log are identical" ]
            then
                echo -e ${COUNTER} - ${green}Success${clear} $pairFlags $patterns $multipleFiles
                let "SUCCESS++"
                printf "\n"
            else
                echo -e ${COUNTER} - ${red}Failed${clear} $pairFlags $patterns $multipleFiles
                printf "\n"
                "$(diff -s "${s21_command[@]}".log "${sys_command[@]}".log)"
                echo "${s21_command[@]}" $flags $patterns $multipleFiles >> "${s21_command[@]}_errors".log
                echo "${sys_command[@]}" $flags $patterns $multipleFiles >> "${sys_command[@]}_errors".log
                let "FAILED++"
                printf "\n"
            fi
                rm -f "${sys_command[@]}".log
                rm -f "${s21_command[@]}".log
        done
    done
done


echo -e SUCCESSED:${green} ${SUCCESS} ${clear}
echo -e FAILED:${red} ${FAILED} ${clear}

