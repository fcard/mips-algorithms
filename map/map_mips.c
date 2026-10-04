typedef int (*int_fn)(int); // int_fn : int -> int

int double_int(int x) {
  return x + x;
}

void map(int size, int* input, int* output, int_fn function) {
  int* end = input + size;
  while (input != end) {
    *output = function(*input);
    input += 1;
    output += 1;
  }
}

int main() {
  int input[10] = {1,2,3,4,5,6,7,8,9,10};
  int output[10] = {0};
  map(10, input, output, double_int);
}
