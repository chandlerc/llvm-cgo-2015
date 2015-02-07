#include <cstring>

static unsigned int h(float value) {
  unsigned int i;
  memcpy(&i, &value, sizeof(value));
  return i;
}

static unsigned char *write(unsigned int v, unsigned char *b) {
  memcpy(b, &v, sizeof(v));
  return b + sizeof(v);
}

static unsigned char *write2(float value, unsigned char *b) {
  return write(h(value), b);
}

void f(float *value, unsigned char *b) { write2(value[0], b); }

void g(float *value, unsigned char *b) { write(h(value[0]), b); }
