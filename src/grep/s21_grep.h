#ifndef SRC_GREP_S21_GREP_H_
#define SRC_GREP_S21_GREP_H_

#define _GNU_SOURCE
#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUF 2048

typedef struct {
  int e_flag;
  int i_flag;
  int v_flag;
  int c_flag;
  int l_flag;
  int n_flag;
  int h_flag;
  int s_flag;
  int f_flag;
  int o_flag;
  int e_f;
  char pattern[BUF];
  char f_file[BUF];
  int print_filename;
  int multiple_files;
} Indicators;

int parsFlags(int argc, char* argv[], Indicators* options);
void reader(char* argv[], Indicators options);
void parsE(Indicators* options);
void flags_o(char* current_line, regex_t compiled, Indicators options,
             int line_counter, char* argv[]);
void print(char* current_line, char* argv[], Indicators options,
           int* match_found, int line_counter);
void patternFromFile(Indicators* options, char* optarg);

#endif  // SRC_GREP_S21_GREP_H_