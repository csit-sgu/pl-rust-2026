#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int *data;
  int length;
  int capacity;
} Vec;

Vec *vec_new() {
  Vec vec;
  vec.data = NULL;
  vec.length = 0;
  vec.capacity = 0;
  return &vec;
}

void vec_push(Vec *vec, int value) {
  if (vec->length == vec->capacity) {
    int new_capacity = vec->capacity * 2;
    int *new_data = (int *) malloc(new_capacity);
    assert(new_data != NULL);
    for (int i = 0; i < vec->length; i++) {
      new_data[i] = vec->data[i];
    }
    vec->data = new_data;
    vec->capacity = new_capacity;
  }
  vec->data[vec->length] = value;
  vec->length++;
}

void vec_free(Vec *vec) {
  free(vec);
  free(vec->data);
}

int main() {
  Vec *vec = vec_new();
  vec_push(vec, 1);
  int *n = &vec->data[0];
  vec_push(vec, 2);
  printf("%d\n", *n);

  free(vec->data);
  vec_free(vec);
}