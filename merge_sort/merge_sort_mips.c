void merge_sort(int size, int* array);
void merge_sort_impl(int size2, int* array);
void merge_sort_join(int s0, int* st, int s1, int* md);

void merge_sort(int size, int* array) {
  merge_sort_impl(size*2, array);
}

void merge_sort_impl(int size2, int* array) {
  int s0, s1, *mid;
  if (size2 < 4) {
    return;
  }
  s0 = size2 - (size2 & 2);
  merge_sort_impl(s0 / 2, array);

  s1 = size2 + (size2 & 2);
  mid = array + (size2 - (size2 & 2))/4;
  merge_sort_impl(s1 / 2, mid);

  merge_sort_join(s0, array, s1, mid);
}

void merge_sort_join(int s0, int* array_start, int s1, int* array_mid) {
  static int aux_start[20] = {0};
  int* aux    = aux_start;
  int* st     = array_start;
  int* st_end = array_start + s0/4;
  int* md     = array_mid;
  int* md_end = array_mid + s1/4;
  int* end;
  while (st != st_end && md != md_end) {
    int a = *st;
    int b = *md;
    if (a < b) {
      *aux = a;
      aux += 1;
      st += 1;
    } else if (b < a) {
      *aux = b;
      aux += 1;
      md += 1;
    } else {
      *aux = a;
      *(aux+1) = b;
      aux += 2;
      st += 1;
      md += 1;
    }
  }
  if (st != st_end || md != md_end) {
    while (st != st_end) {
      *aux = *st;
      aux += 1;
      st += 1;
    }
    while (md != md_end) {
      *aux = *md;
      aux += 1;
      md += 1;
    }
  }
  end = md;
  while (aux != aux_start) {
    *(end-1) = *(aux-1);
    aux -= 1;
    end -= 1;
  }
}

int main() {
  int array[20] = {3,5,19,9,1,4,2,7,10,13,6,16,15,8,11,18,14,12,0,17};
  merge_sort(20, array);
}
