int binary_search(int size, int* array, int key) {
  int start = 0;
  int end = size - 1;

  while (end >= start) {
    int mid = (start + end) / 2;
    if (array[mid] == key) {
      return mid;
    } else if (key < array[mid]) {
      end = mid - 1;
    } else {
      start = mid + 1;
    }
  }
  return -1;
}

int main() {
  int array[20] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
  binary_search(20, array, 10);
}
