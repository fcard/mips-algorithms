void insertion_sort(int size, int* array) {
  int *end, *key_ptr;

  if (size == 0 || size == 1) {
    return;
  }

  key_ptr = array + 1;
  end = array + size;

  while (key_ptr != end) {
    int key = *key_ptr;
    int* next_ptr = key_ptr;
    while (next_ptr != array) {
      int element = *(next_ptr - 1);
      if (element < key) {
        break;
      }
      *next_ptr = element;
      next_ptr -= 1;
    }
    *next_ptr = key;
    key_ptr += 1;
  }
}

int main() {
  int array[20] = {3,5,19,9,1,4,2,7,10,13,6,16,15,8,11,18,14,12,0,17};
  insertion_sort(20, array);
}
