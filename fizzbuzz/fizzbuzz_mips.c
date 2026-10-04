#include <stdio.h>

void fizz_buzz(int n) {
  int i = 0;
  while (i <= n) {
    if (((i % 3) | (i % 5)) == 0) {
      printf("%s", "FizzBuzz\n");
    } else if (i % 3 == 0) {
      printf("%s", "Fizz\n");
    } else if (i % 5 == 0) {
      printf("%s", "Buzz\n");
    } else {
      printf("%d\n", i);
    }
    i += 1;
  }
}

int main() {
  fizz_buzz(20);
}
