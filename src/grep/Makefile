.PHONY: all s21_grep clean test

CC = gcc
CFLAGS = -Wall -Werror -Wextra -Wpedantic -std=c11
NAME = s21_grep
TEST = TestGrep

all: clean s21_grep

s21_grep:
	$(CC) $(CFLAGS) $(NAME).c -o $(NAME)

clean:
	rm -f $(NAME)

test: 
	chmod +x $(TEST).sh
	./$(TEST).sh