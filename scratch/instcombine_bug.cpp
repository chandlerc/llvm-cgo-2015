#include <cstring>

inline unsigned int h(float value) {
  unsigned int i;
  memcpy(&i, &value, sizeof(value));
  return i;
}

inline unsigned char *write(unsigned int v, unsigned char *b) {
  memcpy(b, &v, sizeof(v));
  return b + sizeof(v);
}

inline unsigned char *write2(float value, unsigned char *b) {
  return write(h(value), b);
}

void f(float *value, unsigned char *b) { write2(value[0], b); }

void g(float *value, unsigned char *b) { write(h(value[0]), b); }
