#include "s21_cat.h"

int main(int argc, char* argv[]) {
  Indicators options = {0};
  parsFlags(argc, argv, &options);
  int i = optind;
  for (; i < argc; i++) {
    readFlags(argv[i], &options);
  }
}

void parsFlags(int argc, char* argv[], Indicators* options) {
  int current_flag;
  struct option long_flags[] = {{"number-nonblank", 0, 0, 'b'},
                                {"number", 0, 0, 'n'},
                                {"squeeze-blank", 0, 0, 's'},
                                {"help", 0, NULL, 'h'},
                                {0, 0, 0, 0}};
  while ((current_flag =
              getopt_long(argc, argv, "+beEvnstTv", long_flags, NULL)) != -1) {
    switch (current_flag) {
      case 'b':
        options->b_flag = 1;
        break;
      case 'e':
        options->e_flag = 1;
        options->v_flag = 1;
        break;
      case 'v':
        options->v_flag = 1;
        break;
      case 'n':
        options->n_flag = 1;
        break;
      case 's':
        options->s_flag = 1;
        break;
      case 't':
        options->t_flag = 1;
        options->v_flag = 1;
        break;
      case 'T':
        options->t_flag = 1;
        break;
      case 'E':
        options->e_flag = 1;
        break;
      case 'h':
        showHelp();
        break;
      default:
        fprintf(stderr, "Use --help for help message\n");
        exit(1);
    }
  }
}

// Read file and flags
void readFlags(char* argv, Indicators* options) {
  FILE* file = fopen(argv, "r");

  if (file == NULL) {
    fprintf(stderr, "s21_cat: %s: No such file or directory\n", argv);
  } else {
    int line_counter = 1;
    int flag_s = 0;
    char c = '\0';

    for (char prev = '\n'; !feof(file); prev = c) {
      c = getc(file);
      if (options->s_flag && c == '\n' && prev == '\n') {
        flag_s++;
        if (flag_s > 1) continue;
      } else
        flag_s = 0;

      if (options->b_flag && c != '\n' && prev == '\n' && c != EOF)
        printf("%6d\t", line_counter++);
      if (options->n_flag && !options->b_flag && prev == '\n' && c != EOF)
        printf("%6d\t", line_counter++);
      if (options->e_flag && c == '\n') printf("$");
      if (options->t_flag) {
        if (c == 9) {
          putchar('^');
          putchar('I');
          continue;
        }
      }
      if (options->v_flag) {
        if ((c >= 0 && c < 9) || (c > 10 && c < 32)) {
          putchar('^');
          c += 64;
        }
        if (c == 127) {
          putchar('^');
          putchar('?');
          continue;
        }
      }
      if (c != EOF) printf("%c", c);
    }
    fclose(file);
  }
}

void showHelp() {
  fprintf(stderr, USAGE);
  exit(0);
}