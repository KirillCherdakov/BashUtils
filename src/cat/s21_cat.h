#ifndef SRC_CAT_S21_CAT_H_
#define SRC_CAT_S21_CAT_H_

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUF 2048

#define USAGE "Usage: ./s21_cat [-beEvnstTv] [file ...]\n"

#define FLAGS_HEADER

typedef struct {
  int b_flag; /* numberNonBlank */
  int e_flag; /* endLineSymbol */
  int v_flag; /* nonPrintableSymbols */
  int n_flag; /* numberAllLines; */
  int s_flag; /* squeezeEmptyAdjacentBlankLines */
  int t_flag; /* tabSymbol */
} Indicators;

void parsFlags(int argc, char* argv[], Indicators* flags);
void readFlags(char* argv, Indicators* flags);
void showHelp();

#endif  // SRC_CAT_S21_CAT_H_