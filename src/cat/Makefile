.PHONY: all s21_cat clean test

CC = gcc
CFLAGS = -Wall -Werror -Wextra -Wpedantic -std=c11
NAME = s21_cat
TEST = TestCat

all: clean s21_cat

s21_cat:
	$(CC) $(CFLAGS) $(NAME).c -o $(NAME)

clean:
	rm -f $(NAME)

test: 
	chmod +x $(TEST).sh
	./$(TEST).sh