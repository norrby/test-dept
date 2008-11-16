#include "sut.h"

#include <foo.h>
#include <bar.h>
#include <stdlib.h>

int fooify(int value) {
  int result = foo(value);
  const int unexpected = result <= 0;
  if (unexpected)
    return -1;
  return result;
}

float barify(float value) {
  float result = bar(value);
  const int unexpected = result > 1000;
  if (unexpected)
    return 0.3f;
  return result;
}

char *stringify(char value) {
  char *fie = malloc(2 * sizeof(char));
  if (fie == NULL)
    return "cannot_stringify";
  fie[0] = value;
  fie[1] = '\0';
  return fie;
}
