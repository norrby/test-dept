#include "sut.h"

#include <foo.h>
#include <bar.h>

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

char *fieify(char value) {
  static char fie[2];
  fie[0] = value;
  fie[1] = '\0';
  return fie;
}
