#include <stdio.h>
#include <stdlib.h>

int laplace(int size, int* matrix);
int* create_cofactor_matrix(int size, int* source_matrix, int ignore_line);
void print_matrix(int size, int* matrix);
void populate_matrix(int size, int* matrix);
int* create_matrix(int size);

int main() {
  int size;
  int* matrix;

  printf("Input matrix size below:\n");
  scanf("%d", &size);

  matrix = create_matrix(size);
  populate_matrix(size, matrix);

  print_matrix(size, matrix);

  printf("Determinant is = %d\n", laplace(size, matrix));
  exit(0);
}

int laplace(int size, int* matrix) {
  if (size == 1) {
    return matrix[0];
  } else if (size == 2) {
    return matrix[0] * matrix[3] - matrix[1] * matrix[2];
  } else {
    int i = 0;
    int result = 0;
    while (i < size) {
      i += 1;
      int* m = create_cofactor_matrix(size, matrix, i);
      int n = matrix[size*(i-1)];
      if ((i & 1) == 0) {
        n *= -1;
      }
      result += n * laplace(size-1, m);
    }
    return result;
  }
}

int* create_cofactor_matrix(int size, int* source_matrix, int ignore_line) {
  int* src = source_matrix;
  int* dest = create_matrix(size-1);
  int* m = dest;
  int* end = m + (size-1)*(size-1);
  int* line_start = m;
  int line = 0;

  while (m != end) {
    if (m == line_start) {
      line_start += size-1;
      src += 1;
      line += 1;
      if (line == ignore_line) {
        src += size;
        continue;
      }
    }
    *m = *src;
    m += 1;
    src += 1;
  }
  return dest;
}

void print_matrix(int size, int* matrix) {
  int* end = matrix + size*size;
  int* line_end = matrix + size;
  printf("| ");
  while (1) {
    if (matrix == line_end) {
      printf("|\n");
      line_end += size;
      if (matrix != end) {
        printf("| ");
      } else {
        break;
      }
    }
    printf("%d ", *matrix);
    matrix += 1;
  }
}

void populate_matrix(int size, int* matrix) {
  int* end = matrix + size*size;
  printf("Input matrix values below:\n");
  while (matrix != end) {
    scanf("%d", matrix);
    matrix += 1;
  }
}

int* create_matrix(int size) {
  if (size < 1) {
    printf("Cannot allocate data: size must be a positive integer.\n");
    exit(-1);
  } else if (size > 16000) {
    printf("Cannot allocate data: size too large.\n");
    exit(-1);
  } else {
    int* m = malloc(sizeof(int)*size*size);
    return m;
  }
}
