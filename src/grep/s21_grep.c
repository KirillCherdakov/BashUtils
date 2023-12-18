#include "s21_grep.h"

int main(int argc, char* argv[]) {
  if (argc > 2) {
    Indicators options = {0};
    if (!parsFlags(argc, argv, &options)) {
      if (options.e_f == 0) {
        sprintf(options.pattern, "%s", argv[optind]);
        optind++;
      }
      if (argc - optind > 1) options.multiple_files = 1;
      if (options.multiple_files && !options.h_flag) options.print_filename = 1;
      while (optind < argc) {
        reader(argv, options);
        optind++;
      }
    }
  }
  return 0;
}

int parsFlags(int argc, char* argv[], Indicators* options) {
  int currentFlag = 0;
  int error = 0;
  const char* short_flag = "e:ivclnhsf:o";
  while ((currentFlag = getopt_long(argc, argv, short_flag, 0, 0)) != -1) {
    switch (currentFlag) {
      case 'e':
        options->e_flag = 1;
        parsE(options);
        options->e_f = 1;
        break;
      case 'i':
        options->i_flag = 1;
        break;
      case 'v':
        options->v_flag = 1;
        break;
      case 'c':
        options->c_flag = 1;
        break;
      case 'l':
        options->l_flag = 1;
        break;
      case 'n':
        options->n_flag = 1;
        break;
      case 'h':
        options->h_flag = 1;
        break;
      case 's':
        options->s_flag = 1;
        break;
      case 'f':
        options->f_flag = 1;
        patternFromFile(options, optarg);
        options->e_f = 1;
        break;
      case 'o':
        options->o_flag = 1;
        break;
      default:
        error = 1;
        fprintf(stderr, "usage: ./s21_grep [e:ivclnhsf:o] pattern [file...]\n");
        break;
    }
  }
  if (options->v_flag || options->c_flag || options->l_flag)
    options->o_flag = 0;
  return error;
}

void reader(char* argv[], Indicators options) {
  FILE* file = fopen(argv[optind], "r");
  if (file == NULL) {
    if (!options.s_flag)
      fprintf(stderr, "s21_grep: %s: No such file or directory\n",
              argv[optind]);
  } else {
    int reg_flags = REG_EXTENDED;
    regex_t compiled;
    if (options.i_flag) reg_flags = REG_ICASE;
    if (regcomp(&compiled, options.pattern, reg_flags) == 0) {
      char* current_line = NULL;
      size_t line_size = 0;
      int line_counter = 0;
      int line_found = 0;
      int match_found = 0;
      while (getline(&current_line, &line_size, file) != EOF) {
        line_counter++;
        if (options.o_flag) {
          flags_o(current_line, compiled, options, line_counter, argv);
        } else {
          if (current_line)
            line_found = regexec(&compiled, current_line, 0, 0, 0);
          if (!options.v_flag && !line_found)
            print(current_line, argv, options, &match_found, line_counter);
          else if (options.v_flag && line_found)
            print(current_line, argv, options, &match_found, line_counter);
        }
      }
      if (options.c_flag) {
        if (options.print_filename) printf("%s:", argv[optind]);
        if (options.l_flag && match_found) match_found = 1;  //-lc
        printf("%d\n", match_found);
      }
      if (options.l_flag && match_found) printf("%s\n", argv[optind]);
      if (current_line != NULL) free(current_line);
      regfree(&compiled);
    }
    fclose(file);
  }
}

void parsE(Indicators* options) {
  if ((strlen(options->pattern) + strlen(optarg)) < (BUF - 2)) {
    if (options->e_f) strcat(options->pattern, "|");
    if (strlen(optarg) == 0)
      strcat(options->pattern, ".");
    else
      strcat(options->pattern, optarg);
  }
}
void flags_o(char* current_line, regex_t compiled, Indicators options,
             int line_counter, char* argv[]) {
  regmatch_t pattern_match = {0};
  int opener = 1;
  if (options.v_flag) {
    if (regexec(&compiled, current_line, 1, &pattern_match, 0)) {
      if (options.o_flag) {
        ;
      } else {
        printf("%s", current_line);
      }
    }
  } else {
    if (!regexec(&compiled, current_line, 1, &pattern_match, 0)) {
      if (opener) {
        if (options.print_filename) {
          printf("%s:%.*s\n", argv[optind],
                 (int)(pattern_match.rm_eo - pattern_match.rm_so),
                 current_line + pattern_match.rm_so);
        } else {
          printf("%.*s\n", (int)(pattern_match.rm_eo - pattern_match.rm_so),
                 current_line + pattern_match.rm_so);
        }
        if (options.n_flag) printf("%d:", line_counter);
        opener++;
        char* remaining = current_line + pattern_match.rm_eo;
        while (!regexec(&compiled, remaining, 1, &pattern_match, 0)) {
          printf("%.*s\n", (int)(pattern_match.rm_eo - pattern_match.rm_so),
                 remaining + pattern_match.rm_so);
          remaining += pattern_match.rm_eo;
        }
      }
    }
  }
}

void print(char* current_line, char* argv[], Indicators options,
           int* match_found, int line_counter) {
  if (!options.l_flag && !options.c_flag) {
    if (options.print_filename) printf("%s:", argv[optind]);
    if (options.n_flag) printf("%d:", line_counter);
    char* temp = strchr(current_line, '\n');
    if (temp) *temp = '\0';
    printf("%s\n", current_line);
  }
  (*match_found)++;
}

void patternFromFile(Indicators* options, char* optarg) {
  FILE* file = fopen(optarg, "r");
  if (file == NULL) {
    if (!options->s_flag)
      fprintf(stderr, "s21_grep: %s: No such file or directory\n",
              options->f_file);
  } else {
    char current_line[1] = {'\0'};
    char current = '\0', prev = '\n';
    while ((current = fgetc(file)) != EOF) {
      if (strlen(options->pattern) < (BUF - 2)) {
        if (options->e_f && prev == '\n') {
          strcat(options->pattern, "|");
        }
        if (current != '\n') {
          current_line[0] = current;
          strcat(options->pattern, current_line);
        }
        if (current == '\n' && prev == '\n') {
          strcat(options->pattern, ".");
        }
        if (current == '\n') options->e_f = 1;
        prev = current;
      }
    }
    fclose(file);
  }
}