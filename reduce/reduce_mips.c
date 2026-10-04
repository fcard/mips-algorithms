typedef int (*int_fn2)(int,int); // int_fn2 : int x int -> int

int add_int(int x, int y) {
  return x + y;
}

int reduce(int size, int* input, int init, int_fn2 function) {
  int* end = input + size;
  int result = init;
  while (input != end) {
    result = function(result, *input);
    input += 1;
  }
  return result;
}

int main() {
  int input[10] = {1,2,3,4,5,6,7,8,9,10};
  reduce(10, input, 0, add_int);
}
