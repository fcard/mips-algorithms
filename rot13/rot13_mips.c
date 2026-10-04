#include <stdio.h>

void rot13(char* str) {
  char* ptr = str;
  while (*ptr != 0) {
    char c = *ptr;
    if (c >= 'A' && c <= 'Z') {
      if (c < 'N') {
        *ptr = c + 13;
      } else {
        *ptr = c - 13;
      }
    } else if (c >= 'a' && c <= 'z') {
      if (c < 'n') {
        *ptr = c + 13;
      } else {
        *ptr = c - 13;
      }
    }
    ptr += 1;
  }
}

int main() {
  char str[] = "Hello World!";
  rot13(str);
  printf("%s\n", str);
}
